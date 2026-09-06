import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

class DuasHomeScreen extends StatelessWidget {
  const DuasHomeScreen({super.key});

  // Make this static final (not instance variable)
  static final List<Map<String, String>> _duas = [
    {
      'title': 'Morning Dua',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      'english': 'We have entered the morning and the kingdom belongs to Allah',
      'category': 'Morning',
    },
    {
      'title': 'Evening Dua',
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      'english': 'We have entered the evening and the kingdom belongs to Allah',
      'category': 'Evening',
    },
    {
      'title': 'Before Sleeping',
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'english': 'In Your name, O Allah, I die and I live',
      'category': 'Sleep',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _duas.length,
        itemBuilder: (context, index) {
          final dua = _duas[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dua['title']!,
                  style: const TextStyle(
                    color: AppColors.islamicGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dua['arabic']!,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    color: Colors.white,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dua['english']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}