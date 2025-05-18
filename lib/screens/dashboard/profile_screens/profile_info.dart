// import 'dart:io';

// import 'package:cargorun_rider/providers/auth_provider.dart';
// import 'package:cargorun_rider/constants/shared_prefs.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';

// import '../../../constants/app_colors.dart';
// import '../../../widgets/app_button.dart';
// import '../../../widgets/app_textfields.dart';

// class ProfileInfo extends StatefulWidget {
//   const ProfileInfo({super.key});

//   @override
//   State<ProfileInfo> createState() => _ProfileInfoState();
// }

// class _ProfileInfoState extends State<ProfileInfo> {
//   TextEditingController name = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   TextEditingController email = TextEditingController();
//   String profilePic = '';

//   @override
//   void initState() {
//     setData();
//     super.initState();
//   }

//   void setData() {
//     final profileVM = context.read<AuthProvider>();
//     if (profileVM.user != null) {
//       name.text = profileVM.user!.fullName!;
//       email.text = profileVM.user!.email!;
//       phone.text = profileVM.user!.phone!;
//       profilePic = profileVM.user!.profileImage!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 10.0),
//             Consumer<AuthProvider>(builder: (context, watch, _) {
//               return GestureDetector(
//                 onTap: () => watch.pickProfileImg(context),
//                 child: SizedBox(
//                   child: (watch.profileImg != null)
//                       ? Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 35.0,
//                               backgroundColor: primaryColor2,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Image.file(
//                                   File(watch.profileImg!),
//                                   fit: BoxFit.cover,
//                                   width: size.width,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: -15,
//                               child: IconButton(
//                                 onPressed: () {
//                                   watch.pickProfileImg(context);
//                                 },
//                                 icon: const Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       : profilePic != ""
//                           ? CircleAvatar(
//                               radius: 35.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Image.network(
//                                   profilePic,
//                                   fit: BoxFit.cover,
//                                   width: size.height * 0.1,
//                                   height: size.height * 0.1,
//                                 ),
//                               ),
//                             )
//                           : const CircleAvatar(
//                               radius: 35.0,
//                               backgroundColor: primaryColor2,
//                               child: Center(
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                 ),
//                               ),
//                             ),
//                 ),
//               );
//             }),
//             const SizedBox(height: 40.0),
//             AppTextField(
//               labelText: 'Name',
//               isPassword: false,
//               controller: name,
//             ),
//             const SizedBox(height: 20.0),
//             AppTextField(
//               labelText: 'Phone Number',
//               isPassword: false,
//               controller: phone,
//             ),
//             const SizedBox(height: 20.0),
//             AppTextField(
//               labelText: 'Email',
//               isPassword: false,
//               controller: email,
//             ),
//             const SizedBox(height: 40.0),
//             Consumer<AuthProvider>(builder: (context, watch, _) {
//               return (watch.authState == AuthState.authenticating)
//                   ? const LoadingButton(
//                       textColor: Colors.white,
//                       backgroundColor: primaryColor1,
//                     )
//                   : AppButton(
//                       text: 'Update',
//                       textColor: Colors.white,
//                       backgroundColor: primaryColor1,
//                       hasIcon: false,
//                       onPressed: () async {
//                         sharedPrefs.email = email.text;
//                         sharedPrefs.phone = phone.text;
//                         sharedPrefs.fullName = name.text;

//                         context.read<AuthProvider>().updateProfile(
//                               email: email.text,
//                               phone: phone.text,
//                               name: name.text,
//                             );
//                       },
//                     );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //

import 'dart:io';

import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';

// class ProfileInfo extends StatefulWidget {
//   const ProfileInfo({super.key});

//   @override
//   State<ProfileInfo> createState() => _ProfileInfoState();
// }

// class _ProfileInfoState extends State<ProfileInfo> {
//   final TextEditingController name = TextEditingController();
//   final TextEditingController phone = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isEditing = false;
//   String profilePic = '';

//   @override
//   void initState() {
//     super.initState();
//     setData();
//   }

//   void setData() {
//     final profileVM = context.read<AuthProvider>();
//     if (profileVM.user != null) {
//       name.text = profileVM.user!.fullName ?? '';
//       email.text = profileVM.user!.email ?? '';
//       phone.text = profileVM.user!.phone ?? '';
//       profilePic = profileVM.user!.profileImage ?? '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 10.0),
//             Consumer<AuthProvider>(builder: (context, watch, _) {
//               return GestureDetector(
//                 onTap: () {
//                   if (_isEditing) {
//                     watch.pickProfileImg(context);
//                   }
//                 },
//                 child: SizedBox(
//                   child: (watch.profileImg != null)
//                       ? Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 35.0,
//                               backgroundColor: primaryColor2,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Image.file(
//                                   File(watch.profileImg!),
//                                   fit: BoxFit.cover,
//                                   width: size.width,
//                                 ),
//                               ),
//                             ),
//                             if (_isEditing)
//                               Positioned(
//                                 bottom: 0,
//                                 right: -10,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     watch.pickProfileImg(context);
//                                   },
//                                   icon: const Icon(
//                                     Icons.camera_alt,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               )
//                           ],
//                         )
//                       : profilePic != ""
//                           ? CircleAvatar(
//                               radius: 35.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Image.network(
//                                   profilePic,
//                                   fit: BoxFit.cover,
//                                   width: size.height * 0.1,
//                                   height: size.height * 0.1,
//                                 ),
//                               ),
//                             )
//                           : const CircleAvatar(
//                               radius: 35.0,
//                               backgroundColor: primaryColor2,
//                               child: Center(
//                                 child: Icon(Icons.camera_alt),
//                               ),
//                             ),
//                 ),
//               );
//             }),
//             const SizedBox(height: 40.0),

//             /// Editable form fields
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   EditableTextField(
//                     label: 'Name',
//                     controller: name,
//                     enabled: _isEditing,
//                   ),
//                   const SizedBox(height: 20.0),
//                   EditableTextField(
//                     label: 'Phone Number',
//                     controller: phone,
//                     enabled: _isEditing,
//                   ),
//                   const SizedBox(height: 20.0),
//                   EditableTextField(
//                     label: 'Email',
//                     controller: email,
//                     enabled: _isEditing,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40.0),

//             /// Update or Edit Button
//             Consumer<AuthProvider>(builder: (context, watch, _) {
//               return watch.authState == AuthState.authenticating
//                   ? const LoadingButton(
//                       textColor: Colors.white,
//                       backgroundColor: primaryColor1,
//                     )
//                   : AppButton(
//                       text: _isEditing ? 'Save' : 'Edit',
//                       textColor: Colors.white,
//                       backgroundColor: primaryColor1,
//                       hasIcon: false,
//                       onPressed: () async {
//                         if (_isEditing) {
//                           if (_formKey.currentState!.validate()) {
//                             sharedPrefs.email = email.text;
//                             sharedPrefs.phone = phone.text;
//                             sharedPrefs.fullName = name.text;

//                             await context.read<AuthProvider>().updateProfile(
//                                   email: email.text,
//                                   phone: phone.text,
//                                   name: name.text,
//                                 );
//                             setState(() => _isEditing = false);
//                           }
//                         } else {
//                           setState(() => _isEditing = true);
//                         }
//                       },
//                     );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Custom editable textfield with consistent styling
// class EditableTextField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool enabled;

//   const EditableTextField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.enabled = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       enabled: enabled,
//       validator: (val) =>
//           val == null || val.isEmpty ? '$label cannot be empty' : null,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         suffixIcon: Icon(
//           enabled ? Icons.edit : Icons.lock,
//           color: enabled ? Colors.blue : Colors.grey,
//         ),
//       ),
//     );
//   }
// }

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
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final profileVM = context.read<AuthProvider>();
    if (profileVM.user != null) {
      name.text = profileVM.user!.fullName ?? '';
      email.text = profileVM.user!.email ?? '';
      phone.text = profileVM.user!.phone ?? '';
      profilePic = profileVM.user!.profileImage ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: SizedBox(
                    child: Text(
                  isEditing ? "Done" : "Edit Info",
                  style: TextStyle(color: primaryColor1),
                )),
              ),
            ),
            const SizedBox(height: 10.0),
            Consumer<AuthProvider>(builder: (context, watch, _) {
              return GestureDetector(
                onTap: isEditing ? () => watch.pickProfileImg(context) : null,
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
                            if (isEditing)
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
                          ? Stack(
                              children: [
                                CircleAvatar(
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
                                ),
                                if (isEditing)
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
                          : const CircleAvatar(
                              radius: 35.0,
                              backgroundColor: primaryColor2,
                              child: Center(
                                child: Icon(Icons.camera_alt),
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
              enabled: isEditing,
            ),
            const SizedBox(height: 20.0),
            AppTextField(
              labelText: 'Phone Number',
              isPassword: false,
              controller: phone,
              enabled: isEditing,
            ),
            const SizedBox(height: 20.0),
            AppTextField(
              labelText: 'Email',
              isPassword: false,
              controller: email,
              enabled: isEditing,
            ),
            const SizedBox(height: 40.0),
            if (isEditing)
              Consumer<AuthProvider>(builder: (context, watch, _) {
                return (watch.authState == AuthState.authenticating)
                    ? const LoadingButton(
                        textColor: Colors.white,
                        backgroundColor: primaryColor1,
                      )
                    : AppButton(
                        text: 'Save',
                        textColor: Colors.white,
                        backgroundColor: primaryColor1,
                        hasIcon: false,
                        onPressed: () async {
                          sharedPrefs.email = email.text;
                          sharedPrefs.phone = phone.text;
                          sharedPrefs.fullName = name.text;

                          await context.read<AuthProvider>().updateProfile(
                                email: email.text,
                                phone: phone.text,
                                name: name.text,
                              );

                          setState(() {
                            isEditing = false;
                          });
                        },
                      );
              }),
          ],
        ),
      ),
    );
  }
}
