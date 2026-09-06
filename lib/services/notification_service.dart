import 'github_storage_service.dart';

class NotificationService {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  
  // Create notification
  Future<void> createNotification({
    required String userId,
    required String type,
    required String message,
    String? postId,
  }) async {
    final notifications = await _githubStorage.readNotifications();
    
    notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'type': type,
      'message': message,
      'postId': postId,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
    });
    
    await _githubStorage.storeNotifications(notifications);
  }
  
  // Get notifications for user
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final notifications = await _githubStorage.readNotifications();
    return notifications.where((n) => n['userId'] == userId).toList();
  }
  
  // Get unread count
  Future<int> getUnreadCount(String userId) async {
    final notifications = await getNotifications(userId);
    return notifications.where((n) => n['isRead'] == false).length;
  }
  
  // Mark as read
  Future<void> markAsRead(String notificationId) async {
    final notifications = await _githubStorage.readNotifications();
    for (var notification in notifications) {
      if (notification['id'] == notificationId) {
        notification['isRead'] = true;
        break;
      }
    }
    await _githubStorage.storeNotifications(notifications);
  }
  
  // Mark all as read for user
  Future<void> markAllAsRead(String userId) async {
    final notifications = await _githubStorage.readNotifications();
    for (var notification in notifications) {
      if (notification['userId'] == userId) {
        notification['isRead'] = true;
      }
    }
    await _githubStorage.storeNotifications(notifications);
  }
  
  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final notifications = await _githubStorage.readNotifications();
    notifications.removeWhere((n) => n['id'] == notificationId);
    await _githubStorage.storeNotifications(notifications);
  }
}