import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #$orderId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order status
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.success.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
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
                          'Pesanan Diterima',
                          style: AppTextStyles.subtitle1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pesanan telah sampai',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push('/orders/$orderId/tracking');
                    },
                    child: const Text('Lacak'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Shipping info
            _buildSection(
              context,
              title: 'Informasi Pengiriman',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Penerima', 'John Doe'),
                  _buildInfoRow('No. Telepon', '+62 812 3456 7890'),
                  _buildInfoRow(
                    'Alamat',
                    'Jl. Sudirman No. 123, Jakarta Selatan, DKI Jakarta 12190',
                  ),
                  _buildInfoRow('Kurir', 'JNE - Regular'),
                  _buildInfoRow('No. Resi', 'JNE123456789'),
                ],
              ),
            ),

            const Divider(height: 1),

            // Products
            _buildSection(
              context,
              title: 'Produk yang Dipesan',
              child: Column(
                children: List.generate(
                  3,
                  (index) => ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.medical_services),
                    ),
                    title: Text('Produk ${index + 1}'),
                    subtitle: Text('${index + 1}x Rp 50.000'),
                    trailing: Text(
                      'Rp ${(index + 1) * 50000}',
                      style: AppTextStyles.subtitle2,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Payment summary
            _buildSection(
              context,
              title: 'Rincian Pembayaran',
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', 'Rp 150.000'),
                  _buildPriceRow('Ongkir', 'Rp 15.000'),
                  _buildPriceRow('Biaya Layanan', 'Rp 2.000'),
                  const Divider(height: 24),
                  _buildPriceRow(
                    'Total',
                    'Rp 167.000',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Payment method
            _buildSection(
              context,
              title: 'Metode Pembayaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Metode', 'Cash on Delivery (COD)'),
                ],
              ),
            ),

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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Hubungi Penjual'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Beli Lagi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTextStyles.subtitle1 : AppTextStyles.body2,
          ),
          Text(
            value,
            style: isTotal ? AppTextStyles.price : AppTextStyles.body2,
          ),
        ],
      ),
    );
  }
}
