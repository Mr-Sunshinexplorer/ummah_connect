import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import 'chat_room.dart';
import 'p2p_chat_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community', style: AppTypography.title),
        actions: [
          // P2P Chat button in app bar
          IconButton(
            icon: const Icon(Icons.public, color: AppColors.paradiseGreen),
            tooltip: 'P2P Global Chat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const P2PChatScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Search rooms
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // P2P Global Chat Banner
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.paradiseGreen.withValues(alpha: 0.2),
                    AppColors.secondaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.paradiseGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.paradiseGreen.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.public,
                      color: AppColors.paradiseGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'P2P Global Chat',
                          style: AppTypography.title.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Chat directly with Muslims worldwide - No server needed!',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const P2PChatScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.paradiseGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('CONNECT'),
                  ),
                ],
              ),
            ),
            
            TabBar(
              labelColor: AppColors.islamicGold,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.islamicGold,
              tabs: const [
                Tab(text: 'Rooms'),
                Tab(text: 'Scholars'),
                Tab(text: 'Direct'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRoomsList(context),
                  _buildScholarsList(),
                  _buildDirectMessages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Text('Trending Rooms', style: AppTypography.heading),
        const SizedBox(height: 10),
        _buildRoomCard(
          context,
          name: '#Quran-Reflections',
          members: '1.2k members online',
          description: 'Share your favorite verse today',
          isTrending: true,
        ),
        const SizedBox(height: 10),
        _buildRoomCard(
          context,
          name: '#New-Muslims-Support',
          members: '234 members online',
          description: 'Welcoming all reverts',
          isTrending: false,
        ),
        const SizedBox(height: 10),
        _buildRoomCard(
          context,
          name: '#Youth-Corner',
          members: '567 members online',
          description: 'Islamic perspectives on modern life',
          isTrending: false,
        ),
        const SizedBox(height: 10),
        _buildRoomCard(
          context,
          name: '#Sisters-Room',
          members: '890 members online',
          description: 'A safe space for sisters',
          isTrending: false,
        ),
        const SizedBox(height: 10),
        _buildRoomCard(
          context,
          name: '#Islamic-Finance',
          members: '345 members online',
          description: 'Learn about halal investing',
          isTrending: false,
        ),
      ],
    );
  }

  Widget _buildRoomCard(
    BuildContext context, {
    required String name,
    required String members,
    required String description,
    required bool isTrending,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.islamicGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isTrending ? Icons.local_fire_department : Icons.forum,
              color: isTrending ? Colors.orange : AppColors.islamicGold,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: AppTypography.title.copyWith(fontSize: 16),
                    ),
                    if (isTrending) ...[
                      const SizedBox(width: 5),
                      const Icon(Icons.trending_up, color: Colors.orange, size: 16),
                    ],
                  ],
                ),
                Text(members, style: AppTypography.caption),
                Text(description, style: AppTypography.caption),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoom(roomName: name),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.islamicGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('JOIN'),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarsList() {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        _buildScholarCard(
          name: 'Imam Ahmad',
          status: 'Online',
          specialty: 'Quran & Tafsir',
          rating: 4.9,
          isOnline: true,
        ),
        const SizedBox(height: 10),
        _buildScholarCard(
          name: 'Sheikh Fatima',
          status: 'Online',
          specialty: 'Women\'s Issues',
          rating: 4.8,
          isOnline: true,
        ),
        const SizedBox(height: 10),
        _buildScholarCard(
          name: 'Mufti Ibrahim',
          status: 'Away',
          specialty: 'Islamic Finance',
          rating: 4.7,
          isOnline: false,
        ),
      ],
    );
  }

  Widget _buildScholarCard({
    required String name,
    required String status,
    required String specialty,
    required double rating,
    required bool isOnline,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 35),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? AppColors.paradiseGreen : Colors.grey,
                    border: Border.all(color: AppColors.secondaryDark, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTypography.title.copyWith(fontSize: 16)),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: AppColors.paradiseGreen, size: 16),
                  ],
                ),
                Text(specialty, style: AppTypography.caption),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.islamicGold, size: 14),
                    const SizedBox(width: 5),
                    Text('$rating', style: AppTypography.caption),
                    const SizedBox(width: 10),
                    Text(status, style: TextStyle(
                      color: isOnline ? AppColors.paradiseGreen : Colors.grey,
                      fontSize: 12,
                    )),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              // Start chat with scholar
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDirectMessages() {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        // P2P Chat option in Direct Messages
        _buildP2PDirectMessage(),
        const SizedBox(height: 10),
        _buildDirectMessageCard(
          name: 'Ahmed_1234',
          lastMessage: 'JazakAllah khair for the help!',
          time: '2:30 PM',
          unreadCount: 2,
        ),
        const SizedBox(height: 10),
        _buildDirectMessageCard(
          name: 'Maryam_5678',
          lastMessage: 'See you at the masjid tomorrow',
          time: '11:45 AM',
          unreadCount: 0,
        ),
        const SizedBox(height: 10),
        _buildDirectMessageCard(
          name: 'Yusuf_9012',
          lastMessage: 'Can you share that Quran app?',
          time: 'Yesterday',
          unreadCount: 1,
        ),
      ],
    );
  }

  // P2P Direct Message card
  Widget _buildP2PDirectMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.paradiseGreen.withValues(alpha: 0.2),
            AppColors.secondaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.paradiseGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.paradiseGreen.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.public, color: AppColors.paradiseGreen, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'P2P Global Chat',
                  style: AppTypography.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Chat worldwide without server',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.paradiseGreen),
            onPressed: () {
              // Navigate to P2P chat
              // Need context, so we'll use a callback
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDirectMessageCard({
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.paradiseGreen.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.person, color: AppColors.paradiseGreen, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTypography.title.copyWith(fontSize: 16)),
                    const Spacer(),
                    Text(time, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lastMessage,
                        style: AppTypography.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.islamicGold,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}