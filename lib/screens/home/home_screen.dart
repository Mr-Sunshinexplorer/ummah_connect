import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ummah_connect/screens/home/widgets/community_post.dart';
import 'package:ummah_connect/screens/home/widgets/hadith_card.dart';
import 'package:ummah_connect/screens/home/widgets/stories_row.dart';
import 'package:ummah_connect/screens/home/widgets/verse_card.dart';
import '../../../services/github_storage_service.dart';
import '../../../services/realtime_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../widgets/prayer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  final RealtimeService _realtimeService = RealtimeService();
  final TextEditingController _postController = TextEditingController();
  
  List<Map<String, dynamic>> _globalPosts = [];
  bool _isLoadingPosts = true;
  bool _isPosting = false;
  Timer? _realtimeTimer;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _startRealtimeUpdates();
  }

  // Load posts from GitHub
  Future<void> _loadPosts() async {
    setState(() => _isLoadingPosts = true);
    try {
      final posts = await _githubStorage.readPosts();
      if (mounted) {
        setState(() {
          _globalPosts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      print('Error loading posts: $e');
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  // Start real-time polling
  void _startRealtimeUpdates() {
    _realtimeService.onPostsUpdated = (posts) {
      if (mounted) {
        setState(() {
          _globalPosts = posts;
        });
      }
    };
    _realtimeService.startRealtimeUpdates(intervalSeconds: 10);
  }

  // Create new post
  Future<void> _createPost() async {
    if (_postController.text.isEmpty) return;
    
    setState(() => _isPosting = true);
    
    final post = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': _postController.text,
      'author': 'Abdullah_2847',
      'timestamp': DateTime.now().toIso8601String(),
      'likes': 0,
      'comments': 0,
      'shares': 0,
    };
    
    _globalPosts.insert(0, post);
    
    try {
      await _githubStorage.storePosts(_globalPosts);
      _postController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: AppColors.paradiseGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error saving post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    if (mounted) {
      setState(() => _isPosting = false);
    }
  }

  // Show create post dialog
  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryDark,
          title: const Text(
            'Create Post',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _postController,
            maxLines: 3,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share something beneficial...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.primaryDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _createPost();
              },
              child: const Text('POST', style: TextStyle(color: AppColors.islamicGold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _realtimeService.stopRealtimeUpdates();
    _postController.dispose();
    super.dispose();
  }

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
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _showCreatePostDialog,
            tooltip: 'Create Post',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadPosts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            // Prayer Widget
            const PrayerWidget(),
            const SizedBox(height: 15),
            
            // Stories
            const StoriesRow(),
            const SizedBox(height: 15),
            
            // Daily Verse
            const VerseCard(),
            const SizedBox(height: 15),
            
            // Hadith of the Day
            const HadithCard(),
            const SizedBox(height: 15),
            
            // Community Posts Header with Live indicator
            Row(
              children: [
                Text(
                  'Community Posts',
                  style: AppTypography.heading.copyWith(fontSize: 18),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.paradiseGreen,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Live',
                  style: TextStyle(
                    color: AppColors.paradiseGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Posts from GitHub (Real-time)
            if (_isLoadingPosts) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppColors.islamicGold),
                ),
              ),
            ] else if (_globalPosts.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.article, size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'No posts yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _showCreatePostDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('CREATE FIRST POST'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.islamicGold,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ..._globalPosts.map((post) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CommunityPost(
                  username: post['author'] ?? 'Anonymous',
                  timeAgo: _formatTime(post['timestamp']),
                  content: post['content'] ?? '',
                  likes: post['likes'] ?? 0,
                  comments: post['comments'] ?? 0,
                  shares: post['shares'] ?? 0,
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  // Format timestamp
  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Just now';
    final dateTime = DateTime.tryParse(timestamp);
    if (dateTime == null) return 'Just now';
    
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} min ago';
    if (difference.inDays < 1) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }
}