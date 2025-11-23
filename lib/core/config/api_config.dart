class ApiConfig {
  // Base URL - ganti dengan URL backend yang sebenarnya
  static const String baseUrl = 'https://api.pharmatech.com/v1';

  // API Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String refreshToken = '$auth/refresh-token';

  static const String products = '/products';
  static const String categories = '/categories';
  static const String search = '/search';

  static const String cart = '/cart';
  static const String cartItems = '$cart/items';

  static const String orders = '/orders';
  static const String orderTracking = '/orders/tracking';

  static const String prescriptions = '/prescriptions';
  static const String prescriptionUpload = '$prescriptions/upload';

  static const String consultation = '/consultation';
  static const String pharmacists = '$consultation/pharmacists';
  static const String chat = '$consultation/chat';

  static const String profile = '/profile';
  static const String addresses = '$profile/addresses';

  static const String notifications = '/notifications';

  // API Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';
}
