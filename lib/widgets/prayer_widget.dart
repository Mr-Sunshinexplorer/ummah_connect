import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PrayerWidget extends StatefulWidget {
  const PrayerWidget({super.key});

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.paradiseGreen.withOpacity(0.2),
              AppColors.secondaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.paradiseGreen.withOpacity(0.3),
          ),
        ),
        child: _isExpanded ? _buildExpandedWidget() : _buildCollapsedWidget(),
      ),
    );
  }

  Widget _buildCollapsedWidget() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.paradiseGreen.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.mosque,
            color: AppColors.paradiseGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next Prayer',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Asr - 3:45 PM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.expand_more, color: Colors.white),
      ],
    );
  }

  Widget _buildExpandedWidget() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.paradiseGreen.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.mosque,
                color: AppColors.paradiseGreen,
                size: 25,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Prayer',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    'Asr',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Text(
                  '3:45 PM',
                  style: TextStyle(
                    color: AppColors.paradiseGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '2:34:56 remaining',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Icon(Icons.expand_less, color: Colors.white),
          ],
        ),
        const SizedBox(height: 15),
        const Divider(color: Colors.grey),
        const SizedBox(height: 15),
        _buildPrayerTime('Fajr', '5:23 AM', true),
        _buildPrayerTime('Sunrise', '6:45 AM', false),
        _buildPrayerTime('Dhuhr', '12:30 PM', true),
        _buildPrayerTime('Asr', '3:45 PM', false, isNext: true),
        _buildPrayerTime('Maghrib', '6:15 PM', false),
        _buildPrayerTime('Isha', '7:45 PM', false),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications, size: 16),
              label: const Text('Set Alerts'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.paradiseGreen,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore, size: 16),
              label: const Text('Qibla Direction'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.islamicGold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerTime(String name, String time, bool isCompleted, {bool isNext = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isNext
                  ? AppColors.paradiseGreen
                  : isCompleted
                      ? AppColors.paradiseGreen.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.circle_outlined,
              size: 15,
              color: isNext
                  ? Colors.white
                  : isCompleted
                      ? AppColors.paradiseGreen
                      : Colors.grey,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            name,
            style: TextStyle(
              color: isNext ? AppColors.paradiseGreen : Colors.white,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              color: isNext ? AppColors.paradiseGreen : Colors.white,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.paradiseGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}