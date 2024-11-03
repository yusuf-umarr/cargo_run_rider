import 'package:cargorun_rider/screens/authentication/login_screen.dart';
import 'package:cargorun_rider/screens/authentication/register_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(height: 120),
              Image.asset(
                'assets/images/bg.png',
                height: 70,
              ),
              const SizedBox(height: 60),
              const Text(
                'Become a Cargorun Rider',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome to Cargorun Rider Family! Get ready to embark on exciting journeys, delivering packages with speed and precision. Ready to hit the road and deliver excellence? Let's ride!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              AppButton(
                  text: 'Sign Up as a New Rider',
                  hasIcon: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              AppButton(
                  text: 'Login as an Existing Rider',
                  hasIcon: false,
                  backgroundColor: primaryColor2,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
