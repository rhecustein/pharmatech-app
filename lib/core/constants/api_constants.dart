class ApiConstants {
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Product Endpoints
  static const String products = '/products';
  static const String productDetail = '/products/{id}';
  static const String categories = '/categories';
  static const String searchProducts = '/products/search';

  // Cart Endpoints
  static const String cart = '/cart';
  static const String addToCart = '/cart/items';
  static const String updateCartItem = '/cart/items/{id}';
  static const String removeFromCart = '/cart/items/{id}';

  // Order Endpoints
  static const String orders = '/orders';
  static const String orderDetail = '/orders/{id}';
  static const String createOrder = '/orders';
  static const String cancelOrder = '/orders/{id}/cancel';

  // Prescription Endpoints
  static const String prescriptions = '/prescriptions';
  static const String uploadPrescription = '/prescriptions/upload';
  static const String prescriptionDetail = '/prescriptions/{id}';

  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String readNotification = '/notifications/{id}/read';
  static const String fcmToken = '/user/fcm-token';
}
