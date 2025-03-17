import 'package:cargorun_rider/app.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/shared_prefs.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await NotificationService.initializeNotification();
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