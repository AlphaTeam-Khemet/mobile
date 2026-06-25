class ApiConfig {
  // Point directly to the live production server over secure HTTPS
  static String get baseUrl => 'https://khemetai.com/api';

  static String get mediaBaseUrl => 'https://khemetai.com';

  static String resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$mediaBaseUrl$path';
  }
}
