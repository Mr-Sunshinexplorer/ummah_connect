import 'package:flutter/material.dart';
import '../../../../../theme/colors.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final int points;
  final bool isCompleted;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.points,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCompleted ? AppColors.paradiseGreen : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.paradiseGreen : Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.circle_outlined,
              color: isCompleted ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.islamicGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: AppColors.islamicGold, size: 16),
                const SizedBox(width: 5),
                Text(
                  '+$points',
                  style: const TextStyle(
                    color: AppColors.islamicGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}