import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/search_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/prescription/presentation/pages/prescriptions_page.dart';
import '../../features/prescription/presentation/pages/prescription_upload_page.dart';
import '../../features/prescription/presentation/pages/prescription_detail_page.dart';
import '../../features/scanner/presentation/pages/barcode_scanner_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/addresses_page.dart';
import '../../features/orders/presentation/pages/order_tracking_page.dart';
import '../../features/consultation/presentation/pages/pharmacist_list_page.dart';
import '../../features/consultation/presentation/pages/chat_consultation_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../constants/route_constants.dart';
import '../../shared/widgets/navigation/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: RouteConstants.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteConstants.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main Navigation Shell
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.products,
            name: 'products',
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: RouteConstants.orders,
            name: 'orders',
            builder: (context, state) => const OrdersPage(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Product Routes
      GoRoute(
        path: RouteConstants.productDetail,
        name: 'product-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: RouteConstants.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),

      // Cart Routes
      GoRoute(
        path: RouteConstants.cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: RouteConstants.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),

      // Order Routes
      GoRoute(
        path: RouteConstants.orderDetail,
        name: 'order-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailPage(orderId: id);
        },
      ),
      GoRoute(
        path: '/orders/:id/tracking',
        name: 'order-tracking',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderTrackingPage(orderId: id);
        },
      ),

      // Prescription Routes
      GoRoute(
        path: RouteConstants.prescriptions,
        name: 'prescriptions',
        builder: (context, state) => const PrescriptionsPage(),
      ),
      GoRoute(
        path: '/prescriptions/upload',
        name: 'prescription-upload',
        builder: (context, state) => const PrescriptionUploadPage(),
      ),
      GoRoute(
        path: '/prescriptions/:id',
        name: 'prescription-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PrescriptionDetailPage(prescriptionId: id);
        },
      ),

      // Profile Routes
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/addresses',
        name: 'addresses',
        builder: (context, state) => const AddressesPage(),
      ),

      // Consultation Routes
      GoRoute(
        path: '/consultation',
        name: 'consultation',
        builder: (context, state) => const PharmacistListPage(),
      ),
      GoRoute(
        path: '/consultation/chat/:id',
        name: 'chat-consultation',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChatConsultationPage(pharmacistId: id);
        },
      ),

      // Scanner
      GoRoute(
        path: RouteConstants.scanner,
        name: 'scanner',
        builder: (context, state) => const BarcodeScannerPage(),
      ),

      // Notifications
      GoRoute(
        path: RouteConstants.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      // Settings
      GoRoute(
        path: RouteConstants.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const AboutPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
});
