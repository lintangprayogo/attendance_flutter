import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'auth_local_datasource.dart';
import 'auth_remote_datasource.dart';

class FirebaseMessangingRemoteDatasource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

  //   const initializationSettingsAndroid =
  //       AndroidInitializationSettings('ic_permission');
  //   const initializationSettingsIOS = DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //   );

  //   const initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse:
  //           (NotificationResponse notificationResponse) async {});

  //   final fcmToken = await _firebaseMessaging.getToken();

  //   debugPrint('FCM Token: $fcmToken');

  //   if (await AuthLocalDatasource().getAuthData() != null) {
  //     AuthRemoteDatasource().updateFcm(fcmToken!);
  //   }

  //   FirebaseMessaging.instance.getInitialMessage();
  //   FirebaseMessaging.onMessage.listen((message) {
  //     debugPrint(message.notification?.body);
  //     debugPrint(message.notification?.title);
  //   });

  //   FirebaseMessaging.onMessage.listen(firebaseBackgroundHandler);
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessageOpenedApp.listen(firebaseBackgroundHandler);
  // }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return flutterLocalNotificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //           'com.example.attendance_app', 'app',
  //           importance: Importance.max),
  //       iOS: DarwinNotificationDetails(),
  //     ),
  //   );
   }

  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   await Firebase.initializeApp();

  //   FirebaseMessangingRemoteDatasource().firebaseBackgroundHandler(message);
  // }

  // Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  //   showNotification(
  //     title: message.notification!.title,
  //     body: message.notification!.body,
  //   );
  // }
}
