import 'package:cargorun_rider/constants/app_colors.dart';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/screens/alerts/account_creation_success.dart';
import 'package:cargorun_rider/screens/authentication/verify_otp.dart';
import 'package:cargorun_rider/widgets/app_button.dart';
import 'package:cargorun_rider/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/page_widgets/appbar_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String otp;
  const ResetPasswordScreen({super.key, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(
          successRedirectRoute: SuccessRedirectRoute.passwordSuccess,
        ),
      ),
    );
  }


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Reset password', hasBackBtn: true),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Please enter a new password and continue",
                style: TextStyle(
                  fontSize: 17.0,
                  color: greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60.0),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppTextField(
                          labelText: 'Password',
                          isPassword: true,
                          controller: _passwordController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              await watch.resetPassword(
                                password: _passwordController.text,
                                otp: widget.otp,
                              );
                              if (watch.authState == AuthState.authenticated) {
                                navigate();
                              } else {
                                showSnackBar(watch.errorMessage);
                              }
                            }
                          },
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
