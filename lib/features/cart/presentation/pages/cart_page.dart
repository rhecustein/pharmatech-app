import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/common/empty_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItemData> _cartItems = [
    CartItemData(
      id: '1',
      name: 'Paracetamol 500mg',
      price: 50000,
      quantity: 2,
    ),
    CartItemData(
      id: '2',
      name: 'Vitamin C 1000mg',
      price: 75000,
      quantity: 1,
    ),
    CartItemData(
      id: '3',
      name: 'Obat Batuk Herbal',
      price: 35000,
      quantity: 3,
    ),
  ];

  bool _selectAll = false;
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(_cartItems.map((item) => item.id));
    _selectAll = true;
  }

  double get _subtotal {
    return _cartItems
        .where((item) => _selectedItems.contains(item.id))
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get _shippingCost => 15000;
  double get _total => _subtotal + _shippingCost;

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang'),
        ),
        body: EmptyState(
          message: 'Keranjang Kosong',
          description: 'Belum ada produk di keranjang Anda',
          icon: Icons.shopping_cart_outlined,
          action: PrimaryButton(
            onPressed: () => context.pop(),
            text: 'Mulai Belanja',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang (${_cartItems.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _selectedItems.isEmpty
                ? null
                : () {
                    _showDeleteConfirmation();
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          // Select all
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.background,
            child: Row(
              children: [
                Checkbox(
                  value: _selectAll,
                  onChanged: (value) {
                    setState(() {
                      _selectAll = value ?? false;
                      if (_selectAll) {
                        _selectedItems
                            .addAll(_cartItems.map((item) => item.id));
                      } else {
                        _selectedItems.clear();
                      }
                    });
                  },
                ),
                const Text(
                  'Pilih Semua',
                  style: AppTextStyles.subtitle2,
                ),
              ],
            ),
          ),

          // Cart items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(_cartItems[index]);
              },
            ),
          ),

          // Summary
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemData item) {
    final isSelected = _selectedItems.contains(item.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value ?? false) {
                    _selectedItems.add(item.id);
                  } else {
                    _selectedItems.remove(item.id);
                  }
                  _selectAll = _selectedItems.length == _cartItems.length;
                });
              },
            ),

            // Product image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medical_services,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.subtitle1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${item.price}',
                    style: AppTextStyles.priceSmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Quantity selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (item.quantity > 1) {
                                  setState(() => item.quantity--);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: AppTextStyles.subtitle2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() => item.quantity++);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        onPressed: () {
                          setState(() {
                            _cartItems.remove(item);
                            _selectedItems.remove(item.id);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
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
            // Promo code
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan kode promo',
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: const Text('Pakai'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Price details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: AppTextStyles.body2,
                ),
                Text(
                  'Rp $_subtotal',
                  style: AppTextStyles.body2,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ongkir',
                  style: AppTextStyles.body2,
                ),
                Text(
                  'Rp $_shippingCost',
                  style: AppTextStyles.body2,
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: AppTextStyles.heading4,
                ),
                Text(
                  'Rp $_total',
                  style: AppTextStyles.price,
                ),
              ],
            ),

            const SizedBox(height: 16),

            PrimaryButton(
              onPressed: _selectedItems.isEmpty
                  ? null
                  : () {
                      context.push(RouteConstants.checkout);
                    },
              text: 'Checkout (${_selectedItems.length} item)',
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text(
            'Apakah Anda yakin ingin menghapus ${_selectedItems.length} item dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.removeWhere(
                  (item) => _selectedItems.contains(item.id),
                );
                _selectedItems.clear();
                _selectAll = false;
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemData {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItemData({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
