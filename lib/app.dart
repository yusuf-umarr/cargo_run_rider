import 'package:cargorun_rider/providers/app_provider.dart';
import 'package:cargorun_rider/providers/auth_token_provider.dart';
import 'package:cargorun_rider/providers/bottom_nav_provider.dart';
import 'package:cargorun_rider/screens/onboard/auth_check.dart';
import 'package:cargorun_rider/screens/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CargoRunDriver extends StatefulWidget {
   final String? usedApp;
       static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const CargoRunDriver({super.key, this.usedApp});

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
        home:  MyWidget(usedApp: widget.usedApp)
        
      ),
    );
  }
}


class MyWidget extends StatelessWidget {
  final String? usedApp;
  const MyWidget({super.key,  this.usedApp});

  @override
  Widget build(BuildContext context) {
    if (usedApp!=null) {
      return   const AuthCheckScreen();
      
    }
    return  const OnboardScreen();
  }
}