import 'package:flutter/material.dart';
import 'package:ummah_connect/screens/learn/widgets/challenge_card.dart';
import 'package:ummah_connect/screens/learn/widgets/learning_card.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn & Grow', style: AppTypography.title),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                SizedBox(width: 5),
                Text(
                  '7 Day Streak',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          // Level Progress
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.white, size: 30),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level 5 - Seeker of Knowledge',
                          style: AppTypography.title.copyWith(color: Colors.black),
                        ),
                        Text(
                          '2,450 Hasanat Points',
                          style: TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    color: Colors.black,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '70% to Level 6',
                  style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Categories
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('Quran', true),
                _buildCategoryChip('Hadith', false),
                _buildCategoryChip('Arabic', false),
                _buildCategoryChip('History', false),
                _buildCategoryChip('Fiqh', false),
                _buildCategoryChip('Duas', false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Learning Cards
          const LearningCard(
            title: 'Surah Al-Fatiha',
            type: 'QURAN MEMORIZATION',
            progress: 0.8,
            icon: Icons.menu_book,
            color: AppColors.islamicGold,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          ),
          const SizedBox(height: 15),
          const LearningCard(
            title: '40 Hadith Nawawi',
            type: 'HADITH STUDY',
            progress: 0.5,
            icon: Icons.format_quote,
            color: AppColors.paradiseGreen,
            arabicText: 'إنما الأعمال بالنيات',
          ),
          const SizedBox(height: 15),
          const LearningCard(
            title: 'Arabic Alphabet',
            type: 'ARABIC BASICS',
            progress: 0.3,
            icon: Icons.language,
            color: Colors.blue,
            arabicText: 'ا ب ت ث ج ح خ',
          ),
          const SizedBox(height: 20),
          
          Text('Daily Challenges', style: AppTypography.heading),
          const SizedBox(height: 10),
          const ChallengeCard(
            title: 'Read 5 verses of Quran',
            points: 50,
            isCompleted: false,
          ),
          const SizedBox(height: 10),
          const ChallengeCard(
            title: 'Pray Duha prayer',
            points: 30,
            isCompleted: true,
          ),
          const SizedBox(height: 10),
          const ChallengeCard(
            title: 'Give charity today',
            points: 100,
            isCompleted: false,
          ),
          const SizedBox(height: 10),
          const ChallengeCard(
            title: 'Call your parents',
            points: 40,
            isCompleted: false,
          ),
          const SizedBox(height: 20),
          
          // Achievements
          Text('Achievements', style: AppTypography.heading),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              _buildAchievement('🏆', 'First Prayer', true),
              _buildAchievement('📖', 'Quran Reader', true),
              _buildAchievement('🕌', 'Masjid Goer', true),
              _buildAchievement('🔥', '7 Day Streak', true),
              _buildAchievement('🌟', 'Fasting Warrior', false),
              _buildAchievement('🎓', 'Hafiz Path', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.islamicGold : AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievement(String emoji, String title, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.secondaryDark : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isUnlocked ? AppColors.islamicGold : Colors.grey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUnlocked ? emoji : '🔒',
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 5),
          Text(
            title,
              textAlign: TextAlign.center,

            style: TextStyle(
              color: isUnlocked ? Colors.white : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}