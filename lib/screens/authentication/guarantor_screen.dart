import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfields.dart';
import '/widgets/page_widgets/appbar_widget.dart';

class GuarantorScreen extends StatefulWidget {
  const GuarantorScreen({super.key});

  @override
  State<GuarantorScreen> createState() => _GuarantorScreenState();
}

class _GuarantorScreenState extends State<GuarantorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _guarantor1Name = TextEditingController();
  final TextEditingController _guarantor1Phone = TextEditingController();
  final TextEditingController _guarantor2Name = TextEditingController();
  final TextEditingController _guarantor2Phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, title: 'Verification'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 40,
        ),
        child: Column(
          children: [
            const SizedBox(height: 70.0),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextField(
                        labelText: 'Guarantor 1 Name',
                        isPassword: false,
                        controller: _guarantor1Name,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        labelText: 'Guarantor 1 Phone Number',
                        isPassword: false,
                        hintText: 'eg. 09010218002',
                        controller: _guarantor1Phone,
                        isPhone: true,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        labelText: 'Guarantor 2 Name',
                        isPassword: false,
                        controller: _guarantor2Name,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        labelText: 'Guarantor 2 Phone Number',
                        isPassword: false,
                        hintText: 'eg. 09010218002',
                        controller: _guarantor2Phone,
                        isPhone: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Consumer<AuthProvider>(builder: (context, watch, _) {
              return (watch.authState == AuthState.authenticating)
                  ? const LoadingButton(
                      textColor: Colors.white,
                      backgroundColor: primaryColor1,
                    )
                  : AppButton(
                      text: 'Continue',
                      hasIcon: true,
                      textColor: Colors.white,
                      backgroundColor: primaryColor1,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await watch
                              .addGuarantor(
                                _guarantor1Name.text,
                                _guarantor1Phone.text,
                                _guarantor2Name.text,
                                _guarantor2Phone.text,
                              )
                              .then(
                                (value) => {
                                  if (watch.authState ==
                                      AuthState.authenticated)
                                    {
                                      context.go('/input-phone'),
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(watch.errorMessage),
                                        ),
                                      ),
                                    }
                                },
                              );
                        }
                      },
                    );
            }),
        
          ],
        ),
      ),
    );
  }
}
