// ignore_for_file: use_build_context_synchronously

import 'package:cargorun_rider/screens/authentication/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfields.dart';
import '/widgets/page_widgets/appbar_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Create Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Please create an account to continue.',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: greyText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        AppTextField(
                          labelText: 'Full Name',
                          isPassword: false,
                          controller: _fullName,
                        ),
                        const SizedBox(height: 5.0),
                        AppTextField(
                          labelText: 'Phone',
                          isPassword: false,
                          isPhone: true,
                          controller: _phone,
                        ),
                        const SizedBox(height: 5.0),
                        AppTextField(
                          labelText: 'Password',
                          isPassword: true,
                          controller: _password,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Consumer<AuthProvider>(
                builder: (context, watch, _) {
                  return (watch.authState == AuthState.authenticating)
                      ? const LoadingButton(
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                        )
                      : AppButton(
                          text: 'Continue',
                          hasIcon: true,
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await watch
                                  .register(_fullName.text, _password.text,
                                      _phone.text)
                                  .then((value) => {
                                        if (watch.authState ==
                                            AuthState.authenticated)
                                          {
                                            context
                                                .push('/vehicle-verification'),
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text(watch.errorMessage),
                                              ),
                                            ),
                                          }
                                      });
                            }
                          },
                        );
                },
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                                     Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen(),),);
                          },
                        text: 'Login',
                        style: const TextStyle(
                          color: primaryColor2,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
