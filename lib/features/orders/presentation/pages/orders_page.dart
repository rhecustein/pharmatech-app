import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/empty_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Diproses'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('all'),
          _buildOrderList('processing'),
          _buildOrderList('shipping'),
          _buildOrderList('completed'),
          _buildOrderList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    // Simulate empty state for some tabs
    if (status == 'cancelled') {
      return const EmptyState(
        message: 'Tidak Ada Pesanan Dibatalkan',
        description: 'Pesanan yang dibatalkan akan muncul di sini',
        icon: Icons.cancel_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: status == 'all' ? 5 : 2,
      itemBuilder: (context, index) {
        return _buildOrderCard(index);
      },
    );
  }

  Widget _buildOrderCard(int index) {
    final orderStatuses = ['processing', 'shipping', 'completed'];
    final status = orderStatuses[index % orderStatuses.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/orders/ORD${index + 1}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ORD${1000 + index}',
                    style: AppTextStyles.subtitle1,
                  ),
                  _buildStatusChip(status),
                ],
              ),

              const Divider(height: 24),

              // Order items
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Produk ${index + 1}',
                          style: AppTextStyles.subtitle2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2x item',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (index == 1)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+2',
                        style: AppTextStyles.caption,
                      ),
                    ),
                ],
              ),

              const Divider(height: 24),

              // Order footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pesanan:',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Rp ${(index + 1) * 150000}',
                    style: AppTextStyles.price,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  if (status == 'shipping')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/orders/ORD${index + 1}/tracking');
                        },
                        child: const Text('Lacak Pesanan'),
                      ),
                    ),
                  if (status == 'completed') ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Beli Lagi'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Beri Ulasan'),
                      ),
                    ),
                  ],
                  if (status == 'processing')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showCancelDialog();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: const Text('Batalkan'),
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
      case 'processing':
        color = AppColors.warning;
        label = 'Diproses';
        break;
      case 'shipping':
        color = AppColors.info;
        label = 'Dikirim';
        break;
      case 'completed':
        color = AppColors.success;
        label = 'Selesai';
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan'),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesanan dibatalkan')),
              );
            },
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
