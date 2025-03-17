
import 'package:flutter/material.dart';
import 'package:cargorun_rider/providers/app_provider.dart';
import 'package:cargorun_rider/screens/onboard/auth_check.dart';
import 'package:cargorun_rider/screens/onboard/onboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class CargoRunDriver extends StatefulWidget {
  final String? usedApp;
  final String? token;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const CargoRunDriver({super.key, this.usedApp, this.token,});

  @override
  State<CargoRunDriver> createState() => _CargoRunDriverState();
}

class _CargoRunDriverState extends State<CargoRunDriver> {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: MaterialApp(
          navigatorKey: CargoRunDriver.navigatorKey,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: MyWidget(usedApp: widget.usedApp, token:widget.token, )),
    );
  }
}

class MyWidget extends StatelessWidget {
  final String? usedApp;
  final String? token;
  const MyWidget({super.key, this.usedApp, this.token,});

  @override
  Widget build(BuildContext context) {
    if (usedApp != null) {
      return const AuthCheckScreen();
    }
    return const OnboardScreen();
  }
}
//