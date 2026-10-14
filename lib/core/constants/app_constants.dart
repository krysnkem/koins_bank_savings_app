class AppConstants {
  AppConstants._();

  static const String appName = 'Koins Savings';
  static const String appVersion = '1.0.0';

  // Mock credentials for login
  static const String mockEmail = 'test@bank.com';
  static const String mockPassword = 'Password123';

  // Mock user data
  static const String mockUserName = 'John Doe';
  static const String mockUserEmail = 'test@bank.com';
  static const String mockUserPhone = '+234 801 234 5678';

  // Storage keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keySavingsPlans = 'savings_plans';

  // API
  static const String baseUrl = 'https://dummyjson.com';
}
