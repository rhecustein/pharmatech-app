import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedAddress = 'home';
  String _selectedPayment = 'cod';
  String _selectedShipping = 'regular';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping address
            _buildSection(
              title: 'Alamat Pengiriman',
              icon: Icons.location_on,
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Rumah'),
                    subtitle: const Text(
                        'Jl. Sudirman No. 123, Jakarta Selatan'),
                    value: 'home',
                    groupValue: _selectedAddress,
                    onChanged: (value) {
                      setState(() => _selectedAddress = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Kantor'),
                    subtitle: const Text('Jl. Thamrin No. 456, Jakarta Pusat'),
                    value: 'office',
                    groupValue: _selectedAddress,
                    onChanged: (value) {
                      setState(() => _selectedAddress = value!);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Tambah Alamat Baru'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Order items
            _buildSection(
              title: 'Produk (3 item)',
              icon: Icons.shopping_bag,
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
                      child: const Icon(Icons.medical_services, size: 24),
                    ),
                    title: Text('Produk ${index + 1}'),
                    subtitle: Text('${index + 1}x'),
                    trailing: Text(
                      'Rp ${(index + 1) * 50000}',
                      style: AppTextStyles.subtitle2,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Shipping method
            _buildSection(
              title: 'Metode Pengiriman',
              icon: Icons.local_shipping,
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Regular (3-5 hari)'),
                    subtitle: const Text('Rp 15.000'),
                    value: 'regular',
                    groupValue: _selectedShipping,
                    onChanged: (value) {
                      setState(() => _selectedShipping = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Express (1-2 hari)'),
                    subtitle: const Text('Rp 25.000'),
                    value: 'express',
                    groupValue: _selectedShipping,
                    onChanged: (value) {
                      setState(() => _selectedShipping = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Same Day'),
                    subtitle: const Text('Rp 35.000'),
                    value: 'sameday',
                    groupValue: _selectedShipping,
                    onChanged: (value) {
                      setState(() => _selectedShipping = value!);
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Payment method
            _buildSection(
              title: 'Metode Pembayaran',
              icon: Icons.payment,
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Cash on Delivery (COD)'),
                    value: 'cod',
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() => _selectedPayment = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Transfer Bank'),
                    value: 'bank',
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() => _selectedPayment = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('E-Wallet'),
                    value: 'ewallet',
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() => _selectedPayment = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Credit/Debit Card'),
                    value: 'card',
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() => _selectedPayment = value!);
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Notes
            _buildSection(
              title: 'Catatan Pesanan',
              icon: Icons.note,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tambahkan catatan untuk pesanan Anda...',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Bottom summary
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Subtotal', style: AppTextStyles.body2),
                  Text('Rp 235.000', style: AppTextStyles.body2),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ongkir', style: AppTextStyles.body2),
                  Text('Rp 15.000', style: AppTextStyles.body2),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Total', style: AppTextStyles.heading4),
                  Text('Rp 250.000', style: AppTextStyles.price),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () => _processOrder(),
                text: 'Buat Pesanan',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.heading4,
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }

  void _processOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Pesanan Berhasil!',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan Anda telah dibuat',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/orders');
            },
            child: const Text('Lihat Pesanan'),
          ),
        ],
      ),
    );
  }
}
