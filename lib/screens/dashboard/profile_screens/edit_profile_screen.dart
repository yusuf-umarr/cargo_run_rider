import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';
import '../../../widgets/page_widgets/appbar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, title: 'Edit Profile'),
      body: const Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              labelText: 'Name',
              isPassword: false,
              isSuffix: true,
            ),
            SizedBox(height: 20.0),
            AppTextField(
              labelText: 'Phone Number',
              isPassword: false,
              isSuffix: true,
            ),
            SizedBox(height: 20.0),
            AppTextField(
              labelText: 'Email',
              isPassword: false,
              isSuffix: true,
            ),
            SizedBox(height: 40.0),
            AppButton(
              text: 'Submit Changes',
              hasIcon: false,
              textColor: Colors.white,
              backgroundColor: primaryColor1,
            ),
          ],
        ),
      ),
    );
  }
}
