import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';

AppBar appBarWidget(BuildContext context,
    {required String title, bool isBack = true}) {
  return AppBar(
    toolbarHeight: 120, // default is 56
    toolbarOpacity: 0.5,
    backgroundColor: primaryColor1,
    elevation: 0,
    leadingWidth: double.infinity,
    centerTitle: false,
    leading: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (!isBack)
                ? () => context.go('/home')
                : () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/arrow-left.svg',
              width: 30,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
