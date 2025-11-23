import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PharmacistListPage extends StatelessWidget {
  const PharmacistListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsultasi Apoteker'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari apoteker...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Online'),
                    selected: true,
                    onSelected: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Rating Tertinggi'),
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Pengalaman'),
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Pharmacists list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildPharmacistCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacistCard(BuildContext context, int index) {
    final isOnline = index % 2 == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showConsultationOptions(context, index);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'AP${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apt. Pharmacist ${index + 1}',
                      style: AppTextStyles.subtitle1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${5 + index} tahun pengalaman',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${4.5 + (index * 0.1).toStringAsFixed(1)}',
                          style: AppTextStyles.body2,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${100 + index * 20} ulasan)',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isOnline ? 'Online' : 'Offline',
                            style: AppTextStyles.caption.copyWith(
                              color: isOnline
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isOnline ? 'Tersedia' : 'Tidak tersedia',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showConsultationOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Pilih Metode Konsultasi',
                  style: AppTextStyles.heading4,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColors.primary),
                title: const Text('Chat'),
                subtitle: const Text('Konsultasi via chat'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/consultation/chat/$index');
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: AppColors.primary),
                title: const Text('Video Call'),
                subtitle: const Text('Konsultasi via video call'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to video call
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
