import 'github_storage_service.dart';

class InteractionService {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  
  // Like/Unlike post
  Future<Map<String, dynamic>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    final likes = await _githubStorage.readLikes(postId);
    final isLiked = likes.contains(userId);
    
    if (isLiked) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
    
    await _githubStorage.storeLikes(postId, likes);
    
    // Update post like count
    final posts = await _githubStorage.readPosts();
    for (var post in posts) {
      if (post['id'] == postId) {
        post['likes'] = likes.length;
        post['likedBy'] = likes;
        break;
      }
    }
    await _githubStorage.storePosts(posts);
    
    return {
      'isLiked': !isLiked,
      'likeCount': likes.length,
      'likedBy': likes,
    };
  }
  
  // Add comment
  Future<List<Map<String, dynamic>>> addComment({
    required String postId,
    required String userId,
    required String content,
  }) async {
    final comments = await _githubStorage.readComments(postId);
    
    comments.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    await _githubStorage.storeComments(postId, comments);
    
    // Update post comment count
    final posts = await _githubStorage.readPosts();
    for (var post in posts) {
      if (post['id'] == postId) {
        post['comments'] = comments.length;
        break;
      }
    }
    await _githubStorage.storePosts(posts);
    
    return comments;
  }
  
  // Get comments
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    return await _githubStorage.readComments(postId);
  }
  
  // Get likes
  Future<Map<String, dynamic>> getLikes(String postId, String userId) async {
    final likes = await _githubStorage.readLikes(postId);
    return {
      'likeCount': likes.length,
      'isLiked': likes.contains(userId),
      'likedBy': likes,
    };
  }
  
  // Share post
  Future<void> sharePost(String postId) async {
    final posts = await _githubStorage.readPosts();
    for (var post in posts) {
      if (post['id'] == postId) {
        post['shares'] = (post['shares'] ?? 0) + 1;
        break;
      }
    }
    await _githubStorage.storePosts(posts);
  }
}