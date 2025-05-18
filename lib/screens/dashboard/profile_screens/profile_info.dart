import 'dart:io';

import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  String profilePic = '';

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    final profileVM = context.read<AuthProvider>();
    if (profileVM.user != null) {
      name.text = profileVM.user!.fullName!;
      email.text = profileVM.user!.email!;
      phone.text = profileVM.user!.phone!;
      profilePic = profileVM.user!.profileImage!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final TextEditingController name =
    //     TextEditingController(text: sharedPrefs.fullName);
    // final TextEditingController phone =
    //     TextEditingController(text: sharedPrefs.phone);
    // final TextEditingController email =
    //     TextEditingController(text: sharedPrefs.email);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Consumer<AuthProvider>(builder: (context, watch, _) {
              return GestureDetector(
                onTap: () => watch.pickProfileImg(context),
                child: SizedBox(
                  child: (watch.profileImg != null)
                      ? Stack(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor: primaryColor2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(watch.profileImg!),
                                  fit: BoxFit.cover,
                                  width: size.width,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -15,
                              child: IconButton(
                                onPressed: () {
                                  watch.pickProfileImg(context);
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      : profilePic != ""
                          ? CircleAvatar(
                              radius: 35.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  profilePic,
                                  fit: BoxFit.cover,
                                  width: size.height * 0.1,
                                  height: size.height * 0.1,
                                ),
                              ),
                            )
                          : const CircleAvatar(
                              radius: 35.0,
                              backgroundColor: primaryColor2,
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                ),
                              ),
                            ),
                ),
              );
            }),
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
    );
  }
}
//
