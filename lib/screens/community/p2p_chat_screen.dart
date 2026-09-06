import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/p2p_chat_service.dart';
import '../../theme/colors.dart';

class P2PChatScreen extends StatefulWidget {
  const P2PChatScreen({super.key});

  @override
  State<P2PChatScreen> createState() => _P2PChatScreenState();
}

class _P2PChatScreenState extends State<P2PChatScreen> {
  final P2PChatService _chatService = P2PChatService();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _peerIdController = TextEditingController();
  
  List<Map<String, dynamic>> _messages = [];
  List<String> _connectedPeers = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    _chatService.onMessage = (peerId, message) {
      setState(() {
        _messages.add({
          'peerId': peerId,
          'message': message,
          'isMe': false,
        });
      });
    };

    _chatService.onPeerConnected = (peerId) {
      setState(() {
        _connectedPeers.add(peerId);
      });
    };

    _chatService.onPeerDisconnected = (peerId) {
      setState(() {
        _connectedPeers.remove(peerId);
      });
    };

    await _chatService.initialize();
    _messages = _chatService.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P2P Global Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              // Copy peer ID
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Your Peer ID: ${_chatService.peerId}')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Peer ID Display
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  'Your Peer ID (Share with friends)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  _chatService.peerId,
                  style: GoogleFonts.cairo(
                    color: AppColors.islamicGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Connect to Peer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _peerIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter peer ID to connect',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: AppColors.secondaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_peerIdController.text.isNotEmpty) {
                      _chatService.connectToPeer(_peerIdController.text);
                      _peerIdController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.islamicGold,
                  ),
                  child: const Text('CONNECT'),
                ),
              ],
            ),
          ),
          
          // Connected Peers
          if (_connectedPeers.isNotEmpty)
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: _connectedPeers.map((peerId) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.paradiseGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(Icons.circle, color: Colors.white, size: 8),
                          const SizedBox(width: 5),
                          Text(
                            peerId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['isMe'] == true;
                
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.islamicGold : AppColors.secondaryDark,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            message['peerId'] ?? 'Unknown',
                            style: TextStyle(
                              color: AppColors.paradiseGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          message['message'] ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: AppColors.primaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.islamicGold),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatService.broadcastMessage(_messageController.text);
                      setState(() {
                        _messages.add({
                          'peerId': 'me',
                          'message': _messageController.text,
                          'isMe': true,
                        });
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
  }
}