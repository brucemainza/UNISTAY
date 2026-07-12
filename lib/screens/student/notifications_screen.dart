part of '../../main.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifications = [
    const _Notification(
      title: 'New accommodation available',
      message: 'A new 2-bedroom house has been added near UNZA',
      timestamp: '2 hours ago',
      icon: Icons.home_outlined,
      read: false,
    ),
    const _Notification(
      title: 'Payment successful',
      message: 'Your payment of K1,200 for Mr Chanda\'s Boarding House has been processed',
      timestamp: '5 hours ago',
      icon: Icons.check_circle_outline,
      read: true,
    ),
    const _Notification(
      title: 'Booking confirmation',
      message: 'Your booking for Room 201 has been confirmed',
      timestamp: '1 day ago',
      icon: Icons.event_available_outlined,
      read: true,
    ),
    const _Notification(
      title: 'Price drop alert',
      message: 'A house you liked has reduced its price by K100',
      timestamp: '2 days ago',
      icon: Icons.trending_down_outlined,
      read: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniAppBar(title: 'Notifications'),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationCard(notification: notification);
        },
      ),
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 2,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  void _onTabSelected(int index) {
    if (index == 0) Navigator.pop(context);
    if (index == 1) Navigator.pushNamed(context, Routes.map);
  }
}

class _Notification {
  final String title;
  final String message;
  final String timestamp;
  final IconData icon;
  final bool read;

  const _Notification({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.icon,
    required this.read,
  });
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final _Notification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.read
            ? Colors.white
            : orangePrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.read
              ? Colors.grey.withValues(alpha: 0.2)
              : orangePrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: notification.read
                  ? Colors.grey.withValues(alpha: 0.1)
                  : orangePrimary.withValues(alpha: 0.2),
            ),
            child: Icon(
              notification.icon,
              color: notification.read
                  ? Colors.grey
                  : orangePrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.read)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: orangePrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
