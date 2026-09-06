import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../theme/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final notifications = await _notificationService.getNotifications('current_user');
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              await _notificationService.markAllAsRead('current_user');
              _loadNotifications();
            },
            child: const Text('Mark all read', style: TextStyle(color: AppColors.islamicGold)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.islamicGold))
          : _notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('No notifications yet', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: Icon(
                        _getIcon(notification['type']),
                        color: notification['isRead'] ? Colors.grey : AppColors.islamicGold,
                      ),
                      title: Text(
                        notification['message'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        notification['timestamp'] ?? '',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: notification['isRead']
                          ? null
                          : Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.islamicGold,
                              ),
                            ),
                      onTap: () {
                        _notificationService.markAsRead(notification['id']);
                        _loadNotifications();
                      },
                    );
                  },
                ),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'follow':
        return Icons.person_add;
      case 'post':
        return Icons.article;
      default:
        return Icons.notifications;
    }
  }
}