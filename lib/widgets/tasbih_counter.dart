import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../theme/colors.dart';

class TasbihCounter extends StatefulWidget {
  const TasbihCounter({super.key});

  @override
  State<TasbihCounter> createState() => _TasbihCounterState();
}

class _TasbihCounterState extends State<TasbihCounter> {
  int _count = 0;
  int _target = 33;
  String _currentDhikr = 'SubhanAllah';
  bool _vibrationEnabled = true;

  final List<String> _dhikrOptions = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
    'Astaghfirullah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Tasbih'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Counter Display
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.islamicGold.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: _incrementCount,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_count',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '/ $_target',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _count / _target,
                backgroundColor: Colors.grey.withOpacity(0.3),
                color: AppColors.islamicGold,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Dhikr Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  _currentDhikr,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.islamicGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _dhikrOptions.map((dhikr) {
                    return ChoiceChip(
                      label: Text(dhikr),
                      selected: _currentDhikr == dhikr,
                      onSelected: (selected) {
                        setState(() {
                          _currentDhikr = dhikr;
                          _count = 0;
                          _target = dhikr == 'Allahu Akbar' ? 34 : 33;
                        });
                      },
                      selectedColor: AppColors.islamicGold,
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(
                        color: _currentDhikr == dhikr ? Colors.black : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _vibrationEnabled = !_vibrationEnabled;
                  });
                },
                icon: Icon(
                  _vibrationEnabled ? Icons.vibration : Icons.do_not_disturb,
                ),
                label: Text(_vibrationEnabled ? 'Vibration On' : 'Vibration Off'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _incrementCount() {
    setState(() {
      if (_count < _target) {
        _count++;
        if (_vibrationEnabled) {
          Vibration.vibrate(duration: 50);
        }
        if (_count == _target) {
          _showCompletionDialog();
        }
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _count = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryDark,
          title: const Text(
            'MashaAllah!',
            style: TextStyle(color: AppColors.islamicGold),
          ),
          content: const Text(
            'You completed your dhikr! May Allah accept it from you.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetCounter();
              },
              child: const Text('Alhamdulillah'),
            ),
          ],
        );
      },
    );
  }
}