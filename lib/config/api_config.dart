class ApiConfig {
  static const String baseUrl = 'https://khagan.univibe.uz';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/api/$apiVersion';
  
  // Authentication endpoints
  static const String loginEndpoint = '/authentication/auth/login/';
  static const String createAccountEndpoint = '/authentication/create-account/';
  static const String requestOtpEndpoint = '/authentication/request-otp/';
  static const String verifyEmailEndpoint = '/authentication/verify-email/';
  static const String getProfileEndpoint = '/authentication/api/get-profile/';
  
  // Cart endpoints
  static const String addProductToCartEndpoint = '/cart/addProduct/';
  static const String deleteProductFromCartEndpoint = '/cart/deleteProduct/';
  static const String orderCartEndpoint = '/cart/orderCart/';
  static const String getCartEndpoint = '/cart/getCart/';
  
  // Cards endpoints
  static const String listCardsEndpoint = '/cart/cards/';
  static const String addCardEndpoint = '/cart/cards/';
  
  // Category endpoints
  static const String categoriesEndpoint = '/category/categories/';
  static const String productsEndpoint = '/category/products/';
  static const String productDetailEndpoint = '/category/products/';
  
  // Advertisement endpoints
  static const String adsEndpoint = '/ads/';
}

