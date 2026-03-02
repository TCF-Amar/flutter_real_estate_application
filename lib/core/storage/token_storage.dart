import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  // ── In-memory cache ──────────────────────────────────────
  String? _cachedToken;

  // ── Write ─────────────────────────────────────────────────

  /// Persists the access token, refresh token and optional expiry timestamp.
  /// Also updates the in-memory cache so subsequent [getToken] calls are fast.
  Future<void> saveTokens(
    String token,
    String refreshToken, {
    String? expiresAt,
  }) async {
    _cachedToken = token;
    await Future.wait([
      _secureStorage.write(key: 'token', value: token),
      _secureStorage.write(key: 'refresh_token', value: refreshToken),
      if (expiresAt != null)
        _secureStorage.write(key: 'expires_at', value: expiresAt),
    ]);
  }

  // ── Read ──────────────────────────────────────────────────

  /// Returns the cached access token; falls back to secure storage on first
  /// call or after a fresh install / cache invalidation.
  Future<String?> getToken() async {
    _cachedToken ??= await _secureStorage.read(key: 'token');
    return _cachedToken;
  }

  /// Returns the refresh token from secure storage.
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: 'refresh_token');
  }

  Future<String?> getExpiresAt() async {
    return _secureStorage.read(key: 'expires_at');
  }

  Future<Map<String, String>?> getTokens() async {
    final token = await getToken(); // uses cache
    if (token == null) return null;

    final results = await Future.wait([
      _secureStorage.read(key: 'refresh_token'),
      _secureStorage.read(key: 'expires_at'),
    ]);

    return {
      'token': token,
      'refresh_token': results[0] ?? '',
      'expires_at': results[1] ?? '',
    };
  }

  Future<bool> isTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null || expiresAt.isEmpty) return false;
    try {
      final expiry = DateTime.parse(expiresAt);
      return DateTime.now().isAfter(
        expiry.subtract(const Duration(seconds: 30)),
      );
    } catch (_) {
      return false;
    }
  }

  
  Future<void> deleteTokens() async {
    _cachedToken = null;
    await _secureStorage.deleteAll();
  }
}
