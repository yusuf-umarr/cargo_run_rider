// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String text;
  final VoidCallback? onPressed;
  final bool hasIcon;
  final double? height;
  final double? textSize;
  final double? width;
  const AppButton(
      {super.key,
      this.backgroundColor,
      this.textColor,
      required this.text,
      this.onPressed,
      required this.hasIcon,
      this.height,
      this.textSize,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? 55,
        width: width ?? double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor ?? primaryColor1,
                fontSize: (textSize != null)
                    ? textSize
                    : (text.length < 10)
                        ? 18
                        : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            (hasIcon)
                ? SvgPicture.asset(
                    'assets/images/Arrow 1.svg',
                    color: textColor ?? primaryColor1,
                    theme: SvgTheme(
                      currentColor: textColor ?? primaryColor1,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  const LoadingButton(
      {super.key,
      this.backgroundColor,
      this.textColor,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55,
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
