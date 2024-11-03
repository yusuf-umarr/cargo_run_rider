import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/screens/authentication/login_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/get_help_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    setData();

    super.initState();
  }

  void setData() async {
    final profileVM = context.read<AuthProvider>();
    if (profileVM.user != null) {
      name.text = profileVM.user!.fullName!;
      email.text = profileVM.user!.email!;
      phone.text = profileVM.user!.phone!;
    }
  }

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
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
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
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: FractionallySizedBox(
                                    heightFactor: 0.3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 56,
                                          child: AppBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            leadingWidth: 62,
                                            leading: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(Icons.cancel)),
                                            centerTitle: true,
                                            title: Text(
                                              "Take a break from Cargo run?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            scrolledUnderElevation: 0,
                                            bottom: PreferredSize(
                                              preferredSize: Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  1),
                                              child: const Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              sharedPrefs.clearAll();
                                              navigate();
                                            },
                                            child: const Text("Log out"))
                                      ],
                                    )),
                              );
                            });
                      },
                      icon: const Icon(
                        Iconsax.logout,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                CircleAvatar(
                  radius: 35.0,
                  backgroundColor: primaryColor2,
                  child: Center(
                    child: Text(
                      sharedPrefs.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Image.asset('assets/images/pp.png', height: size.height * 0.12),
                const SizedBox(height: 40.0),
                AppTextField(
                  labelText: 'Name',
                  isPassword: false,
                  controller: name,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Phone Number',
                  isPassword: false,
                  controller: phone,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Email',
                  isPassword: false,
                  controller: email,
                ),
                const SizedBox(height: 40.0),
                Consumer<AuthProvider>(builder: (context, watch, _) {
                  return (watch.authState == AuthState.authenticating)
                      ? const LoadingButton(
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                        )
                      : AppButton(
                          text: 'Update',
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                          hasIcon: false,
                          onPressed: () async {
                            sharedPrefs.email = email.text;
                            sharedPrefs.phone = phone.text;
                            sharedPrefs.fullName = name.text;

                            context.read<AuthProvider>().updateProfile(
                                  email: email.text,
                                  phone: phone.text,
                                  name: name.text,
                                );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
