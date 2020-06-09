import 'package:firebase_messaging/firebase_messaging.dart';

const MECHANIC_TOPIC_NAME = 'mechanic';

class PushNotificationsManager {
  // Private constructor
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init(Function(Map<String, dynamic> message) onMessage) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.subscribeToTopic(MECHANIC_TOPIC_NAME);

      _firebaseMessaging.configure(
          // Foreground
          onMessage: (Map<String, dynamic> message) async {
            onMessage(message);
            print("onMessage" + message.toString());
          },
          // Background
          onResume: (Map<String, dynamic> message) async {},
          // App has been terminated and it needs to reboot
          onLaunch: (Map<String, dynamic> message) async {});

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  Future<String> getoken() async {
    final token = await _firebaseMessaging.getToken();
    return token;
  }
}
