import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class ChatRoom extends StatefulWidget {
  final String roomName;
  
  const ChatRoom({super.key, required this.roomName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'username': 'Fatima_1234',
      'message': 'The verse about the sun running its course is amazing!',
      'time': '9:41 AM',
      'isMe': false,
    },
    {
      'username': 'Anonymous_Scholar',
      'message': 'Yes, this refers to the scientific miracle in the Quran',
      'time': '9:43 AM',
      'isMe': false,
      'isScholar': true,
    },
    {
      'username': 'You',
      'message': 'JazakAllah khair for the explanation!',
      'time': '9:45 AM',
      'isMe': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.roomName, style: const TextStyle(fontSize: 16)),
            const Text(
              '1.2k members online',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show room info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Pinned Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: AppColors.islamicGold.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.push_pin, color: AppColors.islamicGold, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Today\'s topic: Surah Yaseen',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  username: message['username'],
                  message: message['message'],
                  time: message['time'],
                  isMe: message['isMe'],
                  isScholar: message['isScholar'] ?? false,
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
                top: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.white),
                  onPressed: () {
                    // Voice note
                  },
                ),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  onPressed: () {
                    // Attach file
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.islamicGold),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'username': 'You',
                          'message': _messageController.text,
                          'time': 'Now',
                          'isMe': true,
                        });
                        _messageController.clear();
                      });
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

  Widget _buildMessageBubble({
    required String username,
    required String message,
    required String time,
    required bool isMe,
    required bool isScholar,
  }) {
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: isMe ? Colors.black : AppColors.islamicGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (isScholar) ...[
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    color: AppColors.paradiseGreen,
                    size: 14,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 5),
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.black.withOpacity(0.6) : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}