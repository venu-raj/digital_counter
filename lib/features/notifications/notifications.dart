import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsRepository {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await messaging.getToken();

    return settings;
  }
}
