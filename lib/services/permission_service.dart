import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestStorage() async {
    if (await Permission.storage.isGranted) return true;
    if (await Permission.videos.isGranted) return true; // Android 13+

    final results = await [
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ].request();

    return results.values.any((s) => s.isGranted);
  }

  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<void> requestAll() async {
    await [
      Permission.storage,
      Permission.videos,
      Permission.photos,
      Permission.microphone,
      Permission.notification,
    ].request();
  }
}
