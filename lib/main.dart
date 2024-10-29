import 'dart:async';

import 'package:cargorun_rider/app.dart';
import 'package:cargorun_rider/services/foregrand_service.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'constants/shared_prefs.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await NotificationService.initializeNotification();
  //  await initializeLocationPermissions();
  // await initializeService();
  setupLocator();
  runApp(
    CargoRunDriver(
      usedApp: sharedPrefs.usedApp,
    ),
  );
}

