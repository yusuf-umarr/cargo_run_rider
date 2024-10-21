import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_colors.dart';
import '../app_button.dart';

class DeliveryCard extends StatefulWidget {
  const DeliveryCard({super.key});

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  int order = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: primaryColor1,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            (order == 1)
                ? "You're 6 minutes away"
                : (order == 2)
                    ? "You have arrived at pickup point"
                    : "Riding to Destination",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Order ID', value: '186792'),
          const SizedBox(height: 10.0),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
            leading: Image.asset(
              'assets/images/pp.png',
              height: 40,
            ),
            title: const Text(
              'Adesewa Adetoro',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Text(
              '12, Ojuelegba Road, Lagos',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            trailing: const SizedBox(
              width: 58,
              child: Row(
                children: [
                  Icon(Iconsax.call, color: primaryColor2),
                  SizedBox(width: 10),
                  Icon(Iconsax.message, color: primaryColor2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Delivery Fee', value: '₦ 1,980.00'),
          const SizedBox(height: 25.0),
          (order == 1)
              ? AppButton(
                  text: 'Cancel Request',
                  hasIcon: false,
                  width: size.width * 0.6,
                  height: 45,
                  textSize: 16,
                  onPressed: () {
                    setState(() {
                      order = 2;
                    });
                  },
                )
              : (order == 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          child: AppButton(
                            text: 'Start',
                            hasIcon: false,
                            textColor: primaryColor1,
                            onPressed: () {
                              setState(() {
                                order = 3;
                              });
                            },
                            height: 45,
                            textSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          child: AppButton(
                            text: 'Cancel',
                            hasIcon: false,
                            textColor: Colors.white,
                            backgroundColor: primaryColor2,
                            onPressed: () {
                              setState(() {
                                order = 1;
                              });
                            },
                            height: 45,
                            textSize: 14,
                          ),
                        )
                      ],
                    )
                  : AppButton(
                      text: 'Package Delivered',
                      hasIcon: false,
                      textColor: primaryColor2,
                      width: size.width * 0.6,
                      height: 45,
                      textSize: 16,
                      onPressed: () => Navigator.pop(context),
                    )
        ],
      ),
    );
  }

  Widget rowItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: primaryColor2,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
