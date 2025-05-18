import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final bool? isEmail;
  final bool? isPhone;
  final String labelText;
  final bool? isSuffix;
  final bool? enabled;
  final String? hintText;
  const AppTextField({
    super.key,
    required this.labelText,
    this.controller,
    required this.isPassword,
    this.isEmail,
    this.isSuffix,
    this.hintText,
    this.isPhone,
    this.enabled,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            color: blackText,
          ),
        ),
        SizedBox(
          height: 70,
          child: Center(
            child: TextFormField(
              enabled: widget.enabled,
              controller: widget.controller,
              obscureText: widget.isPassword ? obscure : false,
              keyboardType: widget.isEmail == true
                  ? TextInputType.emailAddress
                  : (widget.isPhone == true)
                      ? TextInputType.phone
                      : TextInputType.text,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: greyText.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: greyText.withOpacity(0.2)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 0.0,
                ),
                suffixIcon: (widget.isSuffix != null)
                    ? const Icon(
                        Icons.edit,
                        color: primaryColor1,
                      )
                    : widget.isPassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: greyText,
                            ),
                          )
                        : null,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return '* Required field';
                }
                if (widget.isEmail != null) {
                  if (!val.contains('@')) {
                    return 'Invalid Email';
                  }
                }
                if (widget.isPhone != null) {
                  if (val.length != 11) {
                    return 'Invalid Phone Number';
                  }
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;

  const PhoneTextField({super.key, this.controller});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            color: blackText,
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: greyText),
            ),
            prefixIcon: Container(
              width: 88.0,
              margin: const EdgeInsets.only(right: 10.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              decoration: BoxDecoration(
                  color: const Color(0xffF3F3F3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  border: Border.all(color: greyText)),
              child: const Center(
                child: Row(
                  children: [
                    Text(
                      '+234',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: blackText,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
          maxLength: 10,
        ),
      ],
    );
  }
}
