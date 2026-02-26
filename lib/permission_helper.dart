import 'package:flutter/services.dart';

class PermissionsHelper {
  static const MethodChannel _channel = MethodChannel('overlay_permission');

  static Future<void> openOverlaySettings() async {
    try {
      await _channel.invokeMethod('openOverlaySettings');
    } catch (e) {
      print("Error opening overlay settings: $e");
    }
  }
}
