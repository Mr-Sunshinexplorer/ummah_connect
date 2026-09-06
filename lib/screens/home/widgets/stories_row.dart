import 'package:flutter/material.dart';
import '../../../../../theme/colors.dart';

class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAddStory(),
          const SizedBox(width: 10),
          _buildStoryCircle('📖', 'Quran', AppColors.islamicGold),
          const SizedBox(width: 10),
          _buildStoryCircle('🕋', 'Live', AppColors.paradiseGreen),
          const SizedBox(width: 10),
          _buildStoryCircle('🤲', 'Dua', Colors.blue),
          const SizedBox(width: 10),
          _buildStoryCircle('✨', '24h', Colors.purple),
          const SizedBox(width: 10),
          _buildStoryCircle('🎓', 'Learn', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAddStory() {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        const Text(
          'Your Story',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStoryCircle(String emoji, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}