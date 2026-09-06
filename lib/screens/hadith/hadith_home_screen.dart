import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

class HadithHomeScreen extends StatefulWidget {
  const HadithHomeScreen({super.key});

  @override
  State<HadithHomeScreen> createState() => _HadithHomeScreenState();
}

class _HadithHomeScreenState extends State<HadithHomeScreen> {
  // Sample hadith data (will be replaced with API later)
  final List<Map<String, String>> _hadiths = [
    {
      'arabic': 'إنما الأعمال بالنيات',
      'english': 'Actions are but by intentions',
      'narrator': 'Umar ibn Al-Khattab',
      'grade': 'Sahih',
    },
    {
      'arabic': 'بني الإسلام على خمس',
      'english': 'Islam is built upon five pillars',
      'narrator': 'Abdullah ibn Umar',
      'grade': 'Sahih',
    },
    {
      'arabic': 'من كان يؤمن بالله واليوم الآخر فليقل خيرا أو ليصمت',
      'english': 'Whoever believes in Allah and the Last Day, let him speak good or remain silent',
      'narrator': 'Abu Hurairah',
      'grade': 'Sahih',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _hadiths.length,
        itemBuilder: (context, index) {
          final hadith = _hadiths[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.paradiseGreen.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hadith['arabic']!,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    color: AppColors.islamicGold,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hadith['english']!,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 5),
                    Text(
                      hadith['narrator']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.paradiseGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        hadith['grade']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}