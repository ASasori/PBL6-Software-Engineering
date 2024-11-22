class TokenManager {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _role;

  // Getters và setters cho accessToken
  static String? get accessToken => _accessToken;
  static set accessToken(String? value) {
    _accessToken = value;
  }

  // Getters và setters cho refreshToken
  static String? get refreshToken => _refreshToken;
  static set refreshToken(String? value) {
    _refreshToken = value;
  }

  // Getters và setters cho role
  static String? get role => _role;
  static set role(String? value) {
    _role = value;
  }
}