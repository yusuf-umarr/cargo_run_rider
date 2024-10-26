// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/screens/alerts/account_creation_success.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/page_widgets/appbar_widget.dart';

class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key});

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otp = TextEditingController();

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(
          successRedirectRoute: SuccessRedirectRoute.verifyPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Please enter the verification code sent to\nyour email address',
                style: TextStyle(
                  fontSize: 17.0,
                  color: greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 100.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        OTPTextField(
                          length: 5,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 45,
                          // obscureText: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          style: const TextStyle(fontSize: 18),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          onCompleted: (pin) {
                            setState(() {
                              _otp.text = pin;
                            });
                          },
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Consumer<AuthProvider>(
                builder: (context, watch, _) {
                  return (watch.authState == AuthState.authenticating)
                      ? const LoadingButton(
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                        )
                      : AppButton(
                          text: 'Continue',
                          hasIcon: true,
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              log("ddddd");
                              watch
                                  .verifyEmailOTP(
                                sharedPrefs.email,
                                _otp.text,
                              )
                                  .then(
                                (v) {
                                  if (watch.authState ==
                                      AuthState.authenticated) {
                                    navigate();
                                  } else {
                                    showSnackBar(
                                      "Unable to verify otp, please try again",
                                      context,
                                    );
                                    //
                                  }
                                },
                              );
                            }
                          },
                        );
                },
              ),
              const SizedBox(height: 25.0),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: 'Didn\'t receive the code? ',
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      //.then((v)=>  showSnackBar("Otp sent"));
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await context
                                .read<AuthProvider>()
                                .getEmailOTP(
                                  sharedPrefs.email,
                                )
                                .then((v) => showSnackBar("Otp sent", context,
                                    color: Colors.grey));
                          },
                        text: 'Resend',
                        style: const TextStyle(
                          color: primaryColor2,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
