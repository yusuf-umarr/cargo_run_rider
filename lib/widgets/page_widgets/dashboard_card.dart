import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

class DashboardCard extends StatelessWidget {
  final String num;
  final IconData icon;
  final String title;
  const DashboardCard({
    super.key,
    required this.num,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: greyText.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                num,
                style: GoogleFonts.roboto(
                  fontSize: (num.length > 2) ? 20 : 26,
                  fontWeight: FontWeight.bold,
                  color: primaryColor1,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor1.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: primaryColor1, size: 25.0),
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              color: blackText.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
