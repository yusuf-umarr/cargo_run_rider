import 'package:cargorun_rider/screens/dashboard/home_screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../models/order.dart';
import '/widgets/app_button.dart';

class RequestCard extends StatelessWidget {
  final Order order;
  const RequestCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: primaryColor2,
              child: Center(
                child: Text(
                  order.receiverDetails!.name![0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              order.receiverDetails!.name!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: blackText.withOpacity(0.9),
              ),
            ),
            subtitle: Text(
              order.receiverDetails!.address!,
              style: const TextStyle(
                fontSize: 15.0,
                color: greyText,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.4,
                child: AppButton(
                  text: 'Accept',
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                  height: 45,
                  textSize: 15,
                ),
              ),
              SizedBox(
                width: size.width * 0.4,
                child: AppButton(
                  text: 'Reject',
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor2,
                  onPressed: () {},
                  height: 45,
                  textSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
