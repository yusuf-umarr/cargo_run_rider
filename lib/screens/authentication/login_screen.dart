// ignore_for_file: use_build_context_synchronously

import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/providers/bottom_nav_provider.dart';
import 'package:cargorun_rider/screens/authentication/forgot_password.dart';
import 'package:cargorun_rider/screens/authentication/phone_verify_screen.dart';
import 'package:cargorun_rider/screens/authentication/register_screen.dart';
import 'package:cargorun_rider/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/page_widgets/appbar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ),
    );
  }

  void navigateToVerification() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PhoneVerifyScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Please sign in to continue!',
                style: TextStyle(
                  fontSize: 17.0,
                  color: greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        AppTextField(
                          labelText: 'Email',
                          controller: _emailController,
                          isPassword: false,
                          isEmail: true,
                        ),
                        const SizedBox(height: 20.0),
                        AppTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 7.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ));
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: primaryColor1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        Consumer<AuthProvider>(builder: (context, watch, _) {
                          return (watch.authState == AuthState.authenticating)
                              ? const LoadingButton(
                                  backgroundColor: primaryColor1,
                                  textColor: Colors.white,
                                )
                              : AppButton(
                                  text: 'Sign In',
                                  hasIcon: false,
                                  backgroundColor: primaryColor1,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    context
                                        .read<BottomNavProvider>()
                                        .setNavbarIndex(0);
                                    if (_formKey.currentState!.validate()) {
                                      sharedPrefs.email = _emailController.text;
                                      await watch
                                          .login(
                                            _emailController.text,
                                            _passwordController.text,
                                          )
                                          .then(
                                            (value) => {
                                              if (watch.authState ==
                                                  AuthState.authenticated)
                                                {navigateToHome()}
                                              else
                                                {
                                                  showSnackBar(
                                                    watch.errorMessage,
                                                    context,
                                                  ),
                                                  if (watch.errorMessage ==
                                                      "Rider not verified")
                                                    {
                                                      watch.getEmailOTP(
                                                          _emailController
                                                              .text),
                                                      navigateToVerification()
                                                    }
                                                }
                                            },
                                          );
                                    }
                                  },
                                );
                        }),
                        // const SizedBox(height: 20.0),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: RichText(
                        //     text: TextSpan(
                        //       text: "Don't have an account? ",
                        //       style: const TextStyle(
                        //         color: greyText,
                        //         fontSize: 18.0,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       children: [
                        //         TextSpan(
                        //           recognizer: TapGestureRecognizer()
                        //             ..onTap = () {
                        //               context
                        //                   .read<AuthProvider>()
                        //                   .setAuthState(AuthState.initial);
                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       const RegisterScreen(),
                        //                 ),
                        //               );
                        //             },
                        //           text: 'Sign Up',
                        //           style: const TextStyle(
                        //             color: primaryColor2,
                        //             fontSize: 18.0,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20.0)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
