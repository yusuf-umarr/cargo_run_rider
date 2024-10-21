import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/providers/auth_token_provider.dart';
import 'package:cargorun_rider/providers/bottom_nav_provider.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  //The providers for dependency injection and state management will be added here
  //as the app will use MultiProvider
  static final providers = <SingleChildWidget>[
     ChangeNotifierProvider(create: (_) => AuthTokenProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),

  ];
}
