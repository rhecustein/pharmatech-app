class RouteConstants {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main Routes
  static const String home = '/home';
  static const String search = '/search';
  static const String scanner = '/scanner';

  // Product Routes
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String categories = '/categories';
  static const String categoryProducts = '/categories/:id/products';

  // Cart & Checkout Routes
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Order Routes
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String orderTracking = '/orders/:id/tracking';

  // Prescription Routes
  static const String prescriptions = '/prescriptions';
  static const String prescriptionUpload = '/prescriptions/upload';
  static const String prescriptionDetail = '/prescriptions/:id';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addresses = '/profile/addresses';
  static const String paymentMethods = '/profile/payment-methods';

  // Other Routes
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}
