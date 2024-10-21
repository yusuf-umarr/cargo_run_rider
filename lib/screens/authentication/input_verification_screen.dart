import 'package:cargorun_rider/screens/authentication/phone_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/page_widgets/appbar_widget.dart';

class InputPhoneScreen extends StatefulWidget {
  const InputPhoneScreen({super.key});

  @override
  State<InputPhoneScreen> createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Please enter your email so we can send you your verification code",
                style: TextStyle(
                  fontSize: 17.0,
                  color: greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          labelText: 'Email',
                          isPassword: false,
                          isEmail: true,
                          controller: _email,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<AuthProvider>(builder: (context, watch, _) {
                return (watch.authState == AuthState.authenticating)
                    ? const LoadingButton(
                        textColor: Colors.white,
                        backgroundColor: primaryColor1,
                      )
                    : AppButton(
                        text: 'Continue',
                        textColor: Colors.white,
                        backgroundColor: primaryColor1,
                        hasIcon: true,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            watch.getEmailOTP(_email.text);
                            if (watch.authState == AuthState.authenticated) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PhoneVerifyScreen()));
                              // navigate();
                            } else {
                              // showSnackBar(watch.errorMessage);
                            }
                          }
                        },
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
