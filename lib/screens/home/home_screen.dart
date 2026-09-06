import 'package:flutter/material.dart';
import 'package:ummah_connect/screens/home/widgets/community_post.dart';
import 'package:ummah_connect/screens/home/widgets/hadith_card.dart';
import 'package:ummah_connect/screens/home/widgets/stories_row.dart';
import 'package:ummah_connect/screens/home/widgets/verse_card.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../widgets/prayer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mosque, color: AppColors.islamicGold, size: 28),
            const SizedBox(width: 10),
            Text(
              'Ummah Connect',
              style: AppTypography.title.copyWith(
                color: AppColors.islamicGold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to global map
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh feed
        },
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: const [
            PrayerWidget(),
            SizedBox(height: 15),
            StoriesRow(),
            SizedBox(height: 15),
            VerseCard(),
            SizedBox(height: 15),
            HadithCard(),
            SizedBox(height: 15),
            CommunityPost(
              username: 'AbuBakr_4521',
              timeAgo: '2 hours ago',
              content: 'Just prayed Fajr at the masjid. Alhamdulillah! Who else woke up for Fajr today?',
              likes: 892,
              comments: 156,
              shares: 34,
            ),
            SizedBox(height: 15),
            CommunityPost(
              username: 'Fatima_1234',
              timeAgo: '4 hours ago',
              content: 'Memorized Surah Al-Mulk today! It took me 2 weeks but totally worth it. Never give up on your Quran goals! 📖✨',
              likes: 1234,
              comments: 267,
              shares: 89,
              isLiked: true,
            ),
          ],
        ),
      ),
    );
  }
}