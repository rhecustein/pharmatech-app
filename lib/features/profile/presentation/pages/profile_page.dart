import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(24),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+62 812 3456 7890',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.push('/profile/edit');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Loyalty card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_membership,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Silver Member',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '1,250 Poin',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu items
            _buildMenuSection(
              context,
              title: 'Pesanan',
              items: [
                _MenuItem(
                  icon: Icons.receipt_long,
                  title: 'Pesanan Saya',
                  onTap: () => context.push(RouteConstants.orders),
                ),
                _MenuItem(
                  icon: Icons.local_shipping,
                  title: 'Lacak Pesanan',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.rate_review,
                  title: 'Ulasan Saya',
                  onTap: () {},
                ),
              ],
            ),

            const Divider(height: 1),

            _buildMenuSection(
              context,
              title: 'Akun',
              items: [
                _MenuItem(
                  icon: Icons.location_on,
                  title: 'Alamat Pengiriman',
                  onTap: () => context.push('/profile/addresses'),
                ),
                _MenuItem(
                  icon: Icons.payment,
                  title: 'Metode Pembayaran',
                  onTap: () => context.push('/profile/payment-methods'),
                ),
                _MenuItem(
                  icon: Icons.favorite,
                  title: 'Wishlist',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.notifications,
                  title: 'Notifikasi',
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),

            const Divider(height: 1),

            _buildMenuSection(
              context,
              title: 'Lainnya',
              items: [
                _MenuItem(
                  icon: Icons.help,
                  title: 'Bantuan',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.info,
                  title: 'Tentang Aplikasi',
                  onTap: () => context.push('/settings/about'),
                ),
                _MenuItem(
                  icon: Icons.privacy_tip,
                  title: 'Kebijakan Privasi',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.description,
                  title: 'Syarat & Ketentuan',
                  onTap: () {},
                ),
              ],
            ),

            const Divider(height: 1),

            // Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Keluar',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: AppTextStyles.subtitle2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...items.map(
          (item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: item.onTap,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteConstants.login);
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
