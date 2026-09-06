import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/github_storage_service.dart';
import '../../theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _githubStorage.readUserData('current_user');
      setState(() {
        _userData = userData.isNotEmpty ? userData : _getDefaultProfile();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userData = _getDefaultProfile();
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getDefaultProfile() {
    return {
      'id': 'current_user',
      'name': 'Abdullah_2847',
      'level': 1,
      'hasanatPoints': 0,
      'achievements': [],
    };
  }

  Future<void> _saveProfile() async {
    _userData['timestamp'] = DateTime.now().toIso8601String();
    await _githubStorage.storeUserData(_userData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload, color: Colors.white),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.islamicGold))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
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
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _userData['name'] ?? 'Anonymous',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Level ${_userData['level'] ?? 1}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppColors.islamicGold, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              '${_userData['hasanatPoints'] ?? 0} Points',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
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