import 'package:flutter/material.dart';
import '../../../../../theme/colors.dart';

class CommunityPost extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;

  const CommunityPost({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.islamicGold,
                      AppColors.islamicGold.withOpacity(0.6),
                    ],
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 25),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAction(Icons.favorite, isLiked ? Colors.red : Colors.white, '$likes'),
              _buildAction(Icons.comment_outlined, Colors.white, '$comments'),
              _buildAction(Icons.share_outlined, Colors.white, '$shares'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, Color color, String count) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Text(
          count,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}