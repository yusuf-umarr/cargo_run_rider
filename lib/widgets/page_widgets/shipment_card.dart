import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';

class ShipmentCard extends StatelessWidget {
  final OrderData order;
  const ShipmentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (order.status == "accepted" ||
            order.status == "pending" ||
            order.status == 'picked' ||
            order.status == 'arrived') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripRoutePage(
                order: order,
              ),
            ),
          );
        }

        if (order.status == "delivered") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShipmentDetailsScreen(order: order),
            ),
          );
        }

        /*
           Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripRoutePage(
                          order: widget.order,
                          
                            ),
                      ),
                    );
        */
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
                    DateFormat.yMMMMd()
                        .format(DateTime.parse(order.createdAt!)),
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
                  order.status!.toLowerCase() == "picked"
                      ? "On going".toUpperCase()
                      : order.status!.toUpperCase(),
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
