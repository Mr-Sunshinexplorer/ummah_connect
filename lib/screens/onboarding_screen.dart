import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/anonymous_auth.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showProfileSetup = false;
  
  // Profile setup fields
  String? _selectedGender;
  String? _selectedMadhab;
  String? _location;
  String _generatedName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: _showProfileSetup ? _buildProfileSetup() : _buildOnboarding(),
      ),
    );
  }

  Widget _buildOnboarding() {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildOnboardingPage(
                icon: Icons.public,
                title: 'Connect with Ummah',
                description: 'Join millions of Muslims worldwide instantly without any barriers',
                color: AppColors.paradiseGreen,
              ),
              _buildOnboardingPage(
                icon: Icons.menu_book,
                title: 'Learn & Grow',
                description: 'Access Quran, Hadith, and Islamic knowledge in beautiful, easy-to-use format',
                color: AppColors.islamicGold,
              ),
              _buildOnboardingPage(
                icon: Icons.mosque,
                title: 'Find Your Community',
                description: 'Connect with nearby masjids and Muslims in your area',
                color: Colors.blue,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 30 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.islamicGold
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showProfileSetup = true;
                      });
                    },
                    child: const Text(
                      'SKIP',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        setState(() {
                          _showProfileSetup = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.islamicGold,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'GET STARTED' : 'NEXT',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(icon, size: 100, color: color),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: AppTypography.heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Create Your Identity',
            style: AppTypography.heading,
          ),
          const SizedBox(height: 10),
          Text(
            'Your anonymous Islamic identity',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 30),
          
          // Generated Name
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _generatedName.isEmpty ? 'Your Name_XXXX' : _generatedName,
                  style: AppTypography.title,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Generate random name
                    setState(() {
                      _generatedName = 'Abdullah_${DateTime.now().millisecondsSinceEpoch % 10000}';
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Gender Selection
          Text('Gender (Optional)', style: AppTypography.title),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildGenderOption('Male', Icons.male),
              const SizedBox(width: 10),
              _buildGenderOption('Female', Icons.female),
              const SizedBox(width: 10),
              _buildGenderOption('Private', Icons.lock),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Location
          Text('Location (City only)', style: AppTypography.title),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) => _location = value,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g., Karachi, PK',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.location_on, color: AppColors.islamicGold),
              filled: true,
              fillColor: AppColors.secondaryDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Madhab Selection
          Text('Madhab (Optional)', style: AppTypography.title),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedMadhab,
            items: ['Hanafi', 'Maliki', 'Shafi\'i', 'Hanbali', 'Salafi', 'Other']
                .map((madhab) => DropdownMenuItem(
                      value: madhab,
                      child: Text(madhab),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedMadhab = value;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.secondaryDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _continueAsGuest,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: AppColors.islamicGold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE AS GUEST',
                    style: TextStyle(color: AppColors.islamicGold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _generateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.islamicGold,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'GENERATE PROFILE',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon) {
    final isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = label.toLowerCase();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.islamicGold : AppColors.secondaryDark,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppColors.islamicGold : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continueAsGuest() async {
    final auth = Provider.of<AnonymousAuth>(context, listen: false);
    await auth.generateAnonymousUser(
      gender: 'private',
      location: _location,
      madhab: _selectedMadhab,
    );
    _navigateToMain();
  }

  Future<void> _generateProfile() async {
    final auth = Provider.of<AnonymousAuth>(context, listen: false);
    await auth.generateAnonymousUser(
      gender: _selectedGender ?? 'private',
      location: _location,
      madhab: _selectedMadhab,
    );
    _navigateToMain();
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }
}