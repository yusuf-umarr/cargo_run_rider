import 'package:cargorun_rider/app.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'constants/shared_prefs.dart';
import 'services/service_locator.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await sharedPrefs.init();
//   await NotificationService.initializeNotification();


//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   setupLocator();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]).then((_) {
//     runApp(
//       CargoRunDriver(
//         usedApp: sharedPrefs.usedApp,
//         token: sharedPrefs.usedApp,
//       ),
//     );
//   });
// }



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await NotificationService.initializeNotification();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(); // ← iOS settings added

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS, // ← include this line
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  setupLocator();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      CargoRunDriver(
        usedApp: sharedPrefs.usedApp,
        token: sharedPrefs.usedApp,
      ),
    );
  });
}

//com.ios.pinnacle.howbodi