import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // App settings
          _buildSectionHeader('Aplikasi'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: const Text('Bahasa Indonesia'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/settings/language');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(height: 1),

          // Account settings
          _buildSectionHeader('Akun'),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Ubah Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Biometrik'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Keamanan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(height: 1),

          // Support
          _buildSectionHeader('Dukungan'),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Pusat Bantuan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Hubungi Kami'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/settings/about');
            },
          ),

          const Divider(height: 1),

          // Legal
          _buildSectionHeader('Legal'),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Kebijakan Privasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Syarat & Ketentuan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Lisensi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Version
          Center(
            child: Text(
              'Versi 1.0.0',
              style: AppTextStyles.caption,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.subtitle2.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
