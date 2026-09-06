import 'dart:convert';
import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

class P2PChatService {
  // Free public STUN servers
  static const List<String> _stunServers = [
    'stun:stun.l.google.com:19302',
    'stun:stun1.l.google.com:19302',
    'stun:stun2.l.google.com:19302',
    'stun:stun3.l.google.com:19302',
    'stun:stun4.l.google.com:19302',
  ];

  // Free public signaling server
  static const String _signalingServer = 'wss://signaling.herokuapp.com';
  
  final String _peerId = const Uuid().v4().substring(0, 8);
  final Map<String, RTCPeerConnection> _connections = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  
  WebSocketChannel? _mainSignaling;
  late Box _chatBox;
  
  // Callbacks
  Function(String peerId, String message)? onMessage;
  Function(String peerId)? onPeerConnected;
  Function(String peerId)? onPeerDisconnected;
  Function(String peerId, String error)? onError;
  
  String get peerId => _peerId;
  List<String> get connectedPeers => _connections.keys.toList();

  // Initialize P2P service
  Future<void> initialize() async {
    _chatBox = await Hive.openBox('p2p_chat');
    await _connectToSignaling();
  }

  // Connect to free signaling server
  Future<void> _connectToSignaling() async {
    try {
      _mainSignaling = WebSocketChannel.connect(
        Uri.parse(_signalingServer),
      );

      _mainSignaling!.sink.add(json.encode({
        'type': 'register',
        'peerId': _peerId,
      }));

      _mainSignaling!.stream.listen(
        _handleSignalingMessage,
        onError: (error) {
          print('Signaling error: $error');
        },
        onDone: () {
          print('Signaling disconnected');
        },
      );
    } catch (e) {
      print('Failed to connect to signaling: $e');
    }
  }

  // Handle signaling messages
  void _handleSignalingMessage(dynamic data) {
    try {
      final message = json.decode(data);
      
      switch (message['type']) {
        case 'offer':
          _handleOffer(message);
          break;
        case 'answer':
          _handleAnswer(message);
          break;
        case 'ice-candidate':
          _handleIceCandidate(message);
          break;
        case 'peer-joined':
          _handlePeerJoined(message);
          break;
        case 'peer-left':
          _handlePeerLeft(message);
          break;
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  // Create P2P connection
  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': _stunServers.map((url) => {'urls': url}).toList(),
      'sdpSemantics': 'unified-plan',
    };

    final connection = await createPeerConnection(configuration);

    connection.onIceCandidate = (candidate) {
      _sendSignalingMessage({
        'type': 'ice-candidate',
        'peerId': _peerId,
        'candidate': {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        },
      });
    };

    connection.onConnectionState = (state) {
      print('Connection state: $state');
    };

    return connection;
  }

  // Create data channel for chat
  Future<RTCDataChannel> _createDataChannel(RTCPeerConnection connection) async {
    final dataChannel = await connection.createDataChannel(
      'chat',
      RTCDataChannelInit()
        ..ordered = true
        ..maxRetransmits = 3,
    );

    dataChannel.onDataChannelState = (state) {
      print('Data channel state: $state');
    };

    dataChannel.onMessage = (RTCDataChannelMessage message) {
      if (onMessage != null) {
        onMessage!(_peerId, message.text);
      }
      _saveMessage(_peerId, message.text, false);
    };

    return dataChannel;
  }

  // Connect to a peer
  Future<void> connectToPeer(String remotePeerId) async {
    try {
      final connection = await _createPeerConnection();
      final dataChannel = await _createDataChannel(connection);

      _connections[remotePeerId] = connection;
      _dataChannels[remotePeerId] = dataChannel;

      final offer = await connection.createOffer();
      await connection.setLocalDescription(offer);

      _sendSignalingMessage({
        'type': 'offer',
        'peerId': _peerId,
        'targetPeerId': remotePeerId,
        'sdp': offer.sdp,
      });
    } catch (e) {
      print('Error connecting to peer: $e');
      if (onError != null) {
        onError!(remotePeerId, e.toString());
      }
    }
  }

  // Handle incoming offer
  Future<void> _handleOffer(Map<String, dynamic> message) async {
    final remotePeerId = message['peerId'];
    final connection = await _createPeerConnection();
    final dataChannel = await _createDataChannel(connection);

    _connections[remotePeerId] = connection;
    _dataChannels[remotePeerId] = dataChannel;

    await connection.setRemoteDescription(
      RTCSessionDescription(message['sdp'], 'offer'),
    );

    final answer = await connection.createAnswer();
    await connection.setLocalDescription(answer);

    _sendSignalingMessage({
      'type': 'answer',
      'peerId': _peerId,
      'targetPeerId': remotePeerId,
      'sdp': answer.sdp,
    });
  }

  // Handle answer
  Future<void> _handleAnswer(Map<String, dynamic> message) async {
    final remotePeerId = message['peerId'];
    final connection = _connections[remotePeerId];

    if (connection != null) {
      await connection.setRemoteDescription(
        RTCSessionDescription(message['sdp'], 'answer'),
      );
      
      if (onPeerConnected != null) {
        onPeerConnected!(remotePeerId);
      }
    }
  }

  // Handle ICE candidate
  Future<void> _handleIceCandidate(Map<String, dynamic> message) async {
    final remotePeerId = message['peerId'];
    final connection = _connections[remotePeerId];

    if (connection != null) {
      final candidate = message['candidate'];
      await connection.addCandidate(
        RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ),
      );
    }
  }

  // Handle peer joined
  void _handlePeerJoined(Map<String, dynamic> message) {
    final peerId = message['peerId'];
    if (onPeerConnected != null) {
      onPeerConnected!(peerId);
    }
  }

  // Handle peer left
  void _handlePeerLeft(Map<String, dynamic> message) {
    final peerId = message['peerId'];
    _connections.remove(peerId);
    _dataChannels.remove(peerId);
    
    if (onPeerDisconnected != null) {
      onPeerDisconnected!(peerId);
    }
  }

  // Send message to peer
  void sendMessage(String peerId, String message) {
    final dataChannel = _dataChannels[peerId];
    if (dataChannel != null && dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel.send(RTCDataChannelMessage(message));
      _saveMessage(peerId, message, true);
    }
  }

  // Broadcast to all connected peers
  void broadcastMessage(String message) {
    _dataChannels.forEach((peerId, channel) {
      if (channel.state == RTCDataChannelState.RTCDataChannelOpen) {
        channel.send(RTCDataChannelMessage(message));
        _saveMessage(peerId, message, true);
      }
    });
  }

  // Save message to local storage
  Future<void> _saveMessage(String peerId, String message, bool isMe) async {
    final messages = _chatBox.get('messages') ?? [];
    messages.add({
      'peerId': peerId,
      'message': message,
      'isMe': isMe,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _chatBox.put('messages', messages);
  }

  // Get all messages
  List<Map<String, dynamic>> getMessages() {
    final messages = _chatBox.get('messages') ?? [];
    return List<Map<String, dynamic>>.from(messages);
  }

  // Send signaling message
  void _sendSignalingMessage(Map<String, dynamic> message) {
    _mainSignaling?.sink.add(json.encode(message));
  }

  // Disconnect from peer
  void disconnectFromPeer(String peerId) {
    _connections[peerId]?.close();
    _connections.remove(peerId);
    _dataChannels.remove(peerId);
  }

  // Dispose all connections
  void dispose() {
    _connections.forEach((peerId, connection) {
      connection.close();
    });
    _connections.clear();
    _dataChannels.clear();
    _mainSignaling?.sink.close();
  }
}