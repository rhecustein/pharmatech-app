import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.medical_services,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // App name
            const Text(
              'PharmaTech',
              style: AppTextStyles.heading2,
            ),

            const SizedBox(height: 8),

            // Version
            Text(
              'Versi 1.0.0',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Description
            Text(
              'PharmaTech adalah aplikasi mobile yang memudahkan Anda dalam '
              'membeli produk kesehatan, obat-obatan, dan berkonsultasi dengan apoteker.',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Company info
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'PT Autobot Wijaya',
              style: AppTextStyles.subtitle1,
            ),

            const SizedBox(height: 8),

            Text(
              'Jl. Sudirman No. 123\nJakarta Selatan, DKI Jakarta 12190',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Contact
            _buildContactRow(Icons.email, 'support@pharmatech.com'),
            const SizedBox(height: 8),
            _buildContactRow(Icons.phone, '+62 812 3456 7890'),
            const SizedBox(height: 8),
            _buildContactRow(Icons.language, 'www.pharmatech.com'),

            const SizedBox(height: 32),

            // Copyright
            Text(
              '© 2024 PharmaTech. All rights reserved.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
