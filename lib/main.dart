import 'package:flutter/material.dart';

import 'app.dart';
import 'constants/shared_prefs.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  setupLocator();
  runApp( CargoRunDriver(usedApp:   sharedPrefs.usedApp  ,));
}
