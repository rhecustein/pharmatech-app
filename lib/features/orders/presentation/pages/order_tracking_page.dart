import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Pesanan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking number
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nomor Resi',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'JNE123456789',
                          style: AppTextStyles.heading4,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(text: 'JNE123456789'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nomor resi disalin'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'JNE - Regular',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Estimated delivery
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimasi Tiba',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '20-22 Jan 2024',
                            style: AppTextStyles.subtitle1.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tracking timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Pengiriman',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final events = [
      TrackingEvent(
        title: 'Paket telah diterima',
        description: 'Diterima oleh John Doe',
        time: '18 Jan 2024, 14:30',
        isCompleted: true,
        isActive: true,
      ),
      TrackingEvent(
        title: 'Paket dalam pengiriman',
        description: 'Sedang dikirim ke alamat tujuan',
        time: '18 Jan 2024, 08:00',
        isCompleted: true,
        isActive: false,
      ),
      TrackingEvent(
        title: 'Paket telah sampai di kota tujuan',
        description: 'Jakarta Selatan',
        time: '17 Jan 2024, 22:00',
        isCompleted: true,
        isActive: false,
      ),
      TrackingEvent(
        title: 'Paket dalam perjalanan',
        description: 'Dari Jakarta Pusat ke Jakarta Selatan',
        time: '17 Jan 2024, 15:00',
        isCompleted: true,
        isActive: false,
      ),
      TrackingEvent(
        title: 'Paket telah diterima oleh kurir',
        description: 'Diambil dari penjual',
        time: '17 Jan 2024, 10:00',
        isCompleted: true,
        isActive: false,
      ),
      TrackingEvent(
        title: 'Pesanan dikemas',
        description: 'Penjual sedang mengemas pesanan',
        time: '16 Jan 2024, 14:00',
        isCompleted: true,
        isActive: false,
      ),
      TrackingEvent(
        title: 'Pesanan diproses',
        description: 'Pesanan sedang diproses oleh penjual',
        time: '16 Jan 2024, 10:00',
        isCompleted: true,
        isActive: false,
      ),
    ];

    return Column(
      children: events.asMap().entries.map((entry) {
        final index = entry.key;
        final event = entry.value;
        final isLast = index == events.length - 1;

        return _buildTimelineItem(event, isLast);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(TrackingEvent event, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: event.isActive
                    ? AppColors.success
                    : event.isCompleted
                        ? AppColors.primary
                        : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                event.isActive
                    ? Icons.check_circle
                    : event.isCompleted
                        ? Icons.check
                        : Icons.circle,
                size: 16,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: event.isCompleted
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.divider,
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Event details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: event.isActive
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.time,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TrackingEvent {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isActive;

  TrackingEvent({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isActive,
  });
}
