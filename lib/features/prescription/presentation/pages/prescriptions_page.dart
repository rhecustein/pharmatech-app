import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Saya'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildPrescriptionCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/prescriptions/upload');
        },
        icon: const Icon(Icons.add),
        label: const Text('Upload Resep'),
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context, int index) {
    final statuses = ['pending', 'approved', 'rejected'];
    final status = statuses[index % statuses.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/prescriptions/RX${index + 1}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RX${1000 + index}',
                    style: AppTextStyles.subtitle1,
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dr. Jane Smith',
                          style: AppTextStyles.subtitle2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '15 Jan 2024',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 8),
                        if (status == 'approved')
                          const Text(
                            'Resep disetujui oleh Apoteker',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                            ),
                          )
                        else if (status == 'rejected')
                          const Text(
                            'Resep ditolak',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                            ),
                          )
                        else
                          const Text(
                            'Menunggu verifikasi',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
        break;
      case 'approved':
        color = AppColors.success;
        label = 'Disetujui';
        break;
      case 'rejected':
        color = AppColors.error;
        label = 'Ditolak';
        break;
      default:
        color = AppColors.textSecondary;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
