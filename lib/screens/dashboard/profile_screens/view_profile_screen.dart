import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/screens/authentication/login_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/edit_profile_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/get_help_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GetHelpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Get Help',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        color: blackText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Iconsax.setting_2,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Image.asset('assets/images/pp.png', height: size.height * 0.12),
              const SizedBox(height: 40.0),
              AppTextField(
                  labelText: 'Name', isPassword: false, controller: name),
              const SizedBox(height: 20.0),
              AppTextField(
                  labelText: 'Phone Number',
                  isPassword: false,
                  controller: phone),
              const SizedBox(height: 20.0),
              AppTextField(
                  labelText: 'Email', isPassword: false, controller: email),
              const SizedBox(height: 40.0),
              AppButton(
                text: 'Sign out',
                hasIcon: false,
                textColor: Colors.white,
                backgroundColor: primaryColor1,
                onPressed: () {
                  sharedPrefs.clearAll();
                  navigate();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
