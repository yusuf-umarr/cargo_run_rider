import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/order.dart';

class ShipmentCard extends StatelessWidget {
  final Order order;
  const ShipmentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShipmentScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Order',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: blackText,
                          ),
                        ),
                        TextSpan(
                          text: ' #${order.orderId}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: primaryColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    DateFormat.yMMMMd().format(order.createdAt!),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: blackText,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    order.receiverDetails!.address!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: blackText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.status!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: switch (order.status!) {
                      'pending' => Colors.orange,
                      'delivered' => Colors.green,
                      'cancelled' => Colors.red,
                      _ => blackText
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "₦${order.deliveryFee}",
                  style: GoogleFonts.roboto(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: blackText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
