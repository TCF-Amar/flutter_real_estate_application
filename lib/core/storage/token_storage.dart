import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  //! Save tokens + expiry
  Future<void> saveTokens(
    String token,
    String refreshToken, {
    String? expiresAt,
  }) async {
    await _secureStorage.write(key: 'token', value: token);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    if (expiresAt != null) {
      await _secureStorage.write(key: 'expires_at', value: expiresAt);
    }
  }

  //! Get access token only
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  //! Get refresh token only
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  //! Get expiry
  Future<String?> getExpiresAt() async {
    return await _secureStorage.read(key: 'expires_at');
  }

  //! Get all tokens (returns null if access token is missing)
  Future<Map<String, String>?> getTokens() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) return null;
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    final expiresAt = await _secureStorage.read(key: 'expires_at');
    return {
      'token': token,
      'refresh_token': ?refreshToken,
      'expires_at': ?expiresAt,
    };
  }

  //! Check if token is expired (with 30s buffer)
  Future<bool> isTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return false;
    try {
      final expiry = DateTime.parse(expiresAt);
      return DateTime.now().isAfter(
        expiry.subtract(const Duration(seconds: 30)),
      );
    } catch (_) {
      return false;
    }
  }

  //! Delete all tokens
  Future<void> deleteTokens() async {
    await _secureStorage.deleteAll();
  }
}
