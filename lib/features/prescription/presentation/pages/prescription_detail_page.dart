import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrescriptionDetailPage extends StatelessWidget {
  final String prescriptionId;

  const PrescriptionDetailPage({
    super.key,
    required this.prescriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resep #$prescriptionId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.success.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resep Disetujui',
                          style: AppTextStyles.subtitle1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Diverifikasi oleh Apt. Jane Smith',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Prescription image
            Container(
              margin: const EdgeInsets.all(16),
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            // Prescription info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Resep',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Nomor Resep', prescriptionId),
                  _buildInfoRow('Nama Dokter', 'Dr. Jane Smith'),
                  _buildInfoRow('Tanggal Upload', '15 Jan 2024, 10:30'),
                  _buildInfoRow('Tanggal Verifikasi', '15 Jan 2024, 14:00'),
                  _buildInfoRow('Apoteker', 'Apt. John Doe'),
                  _buildInfoRow('Status', 'Disetujui', isStatus: true),
                ],
              ),
            ),

            const Divider(height: 1),

            // Prescribed medicines
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Obat yang Diresepkan',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    3,
                    (index) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.medical_services),
                        ),
                        title: Text('Obat ${index + 1}'),
                        subtitle: Text('3x sehari, sesudah makan'),
                        trailing: Text(
                          'Rp 50.000',
                          style: AppTextStyles.priceSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notes
            if (true) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan Apoteker',
                      style: AppTextStyles.heading4,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pastikan mengonsumsi obat sesuai dengan dosis yang telah ditentukan. '
                        'Jika ada efek samping, segera hubungi dokter atau apoteker.',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Bottom actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              // Order medicines
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Pesan Obat'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: AppTextStyles.body2,
                  ),
          ),
        ],
      ),
    );
  }
}
