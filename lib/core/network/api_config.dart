class ApiConfig {
  static const bool useDeviceLan = true;
  static const String _lanIp = '192.168.1.18';
  static const String _emulatorIp = '10.0.2.2';

  static String get _host => useDeviceLan ? _lanIp : _emulatorIp;

  static String get baseUrl => 'http://$_host:3000/api';

  static String get mediaBaseUrl => 'http://$_host:3000';

  static String resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$mediaBaseUrl$path';
  }
}
