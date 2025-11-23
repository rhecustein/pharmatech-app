import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/empty_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Pesanan Dikirim',
      message: 'Pesanan #ORD1001 sedang dalam perjalanan',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: 'order',
    ),
    NotificationItem(
      id: '2',
      title: 'Promo Spesial!',
      message: 'Diskon 20% untuk semua produk vitamin',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      type: 'promo',
    ),
    NotificationItem(
      id: '3',
      title: 'Resep Disetujui',
      message: 'Resep #RX1002 telah disetujui oleh apoteker',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'prescription',
    ),
    NotificationItem(
      id: '4',
      title: 'Pesanan Selesai',
      message: 'Pesanan #ORD1000 telah selesai. Beri ulasan yuk!',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: 'order',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi${unreadCount > 0 ? " ($unreadCount)" : ""}'),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification.isRead = true;
                  }
                });
              },
              child: const Text('Tandai Semua Dibaca'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const EmptyState(
              message: 'Tidak Ada Notifikasi',
              description: 'Notifikasi Anda akan muncul di sini',
              icon: Icons.notifications_off_outlined,
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifikasi dihapus')),
        );
      },
      child: Container(
        color: notification.isRead ? null : AppColors.primary.withOpacity(0.05),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getNotificationColor(notification.type),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: Colors.white,
            ),
          ),
          title: Text(
            notification.title,
            style: AppTextStyles.subtitle2,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.time),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'promo':
        return Icons.discount;
      case 'prescription':
        return Icons.medical_services;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.info;
      case 'promo':
        return AppColors.secondary;
      case 'prescription':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final String type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
