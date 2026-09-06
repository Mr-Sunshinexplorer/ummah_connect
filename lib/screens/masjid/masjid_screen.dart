import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

class MasjidScreen extends StatelessWidget {
  const MasjidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masjid Finder', style: AppTypography.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore, color: Colors.white),
            onPressed: () {
              // Open Qibla finder
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Map View',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      // Locate me
                    },
                    backgroundColor: AppColors.islamicGold,
                    child: const Icon(Icons.my_location, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                Text('Nearby Masjids', style: AppTypography.heading),
                const SizedBox(height: 10),
                _buildMasjidCard(
                  name: 'Masjid Al-Noor',
                  distance: '0.5 km',
                  rating: 4.8,
                  nextPrayer: 'Asr 3:45 PM',
                  peopleGoing: 45,
                  isOpen: true,
                ),
                const SizedBox(height: 10),
                _buildMasjidCard(
                  name: 'Islamic Center',
                  distance: '1.2 km',
                  rating: 4.5,
                  nextPrayer: 'Asr 3:45 PM',
                  peopleGoing: 23,
                  isOpen: true,
                ),
                const SizedBox(height: 10),
                _buildMasjidCard(
                  name: 'Jamia Masjid',
                  distance: '2.0 km',
                  rating: 4.7,
                  nextPrayer: 'Asr 3:45 PM',
                  peopleGoing: 67,
                  isOpen: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasjidCard({
    required String name,
    required String distance,
    required double rating,
    required String nextPrayer,
    required int peopleGoing,
    required bool isOpen,
  }) {
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.paradiseGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.mosque,
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
                      name,
                      style: AppTypography.title,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.islamicGold, size: 16),
                        const SizedBox(width: 5),
                        Text('$rating', style: AppTypography.caption),
                        const SizedBox(width: 10),
                        Text(distance, style: AppTypography.caption),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isOpen ? AppColors.paradiseGreen : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isOpen ? 'OPEN' : 'CLOSED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 5),
              Text('Next Prayer: $nextPrayer', style: AppTypography.caption),
              const Spacer(),
              Icon(Icons.people, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 5),
              Text('$peopleGoing going', style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Get directions
                  },
                  icon: const Icon(Icons.directions, size: 20),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.islamicGold,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // View details
                  },
                  icon: const Icon(Icons.info_outline, size: 20),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}