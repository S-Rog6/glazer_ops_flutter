import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<void> dialPhoneNumber(String phone) async {
    final normalized = phone.trim();
    if (normalized.isEmpty || normalized == '--') {
      return;
    }

    final phoneNumber = normalized.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    // We launch directly, and if it fails, the caller can handle it
    // or we can let it fail silently depending on requirements.
    // The previous implementation showed a snackbar via context.
    final launched = await launchUrl(uri);
    if (!launched) {
      throw Exception('Unable to open phone app.');
    }
  }

  static Future<void> openMapLocation(String query) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw Exception('Unable to open maps.');
    }
  }
}
