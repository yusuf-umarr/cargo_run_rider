// ignore_for_file: use_build_context_synchronously

import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_details.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';

class ShipmentCard extends StatefulWidget {
  final OrderData order;
  const ShipmentCard({super.key, required this.order});

  @override
  State<ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<ShipmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // if (widget.order.status == "accepted" ||
        //     widget.order.status == "pending" ||
        //     widget.order.status == 'picked' ||
        //     widget.order.status == 'arrived') {
        //   await context.read<OrderProvider>().setOrder(widget.order);

        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => TripRoutePage(
        //         order: widget.order,
        //       ),
        //     ),
        //   );
        // }

        // if (widget.order.status == "delivered") {

        await context.read<OrderProvider>().setOrder(widget.order);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShipmentDetailsScreen(),
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
                          text: ' #${widget.order.orderId}',
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
                        .format(DateTime.parse(widget.order.createdAt!)),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: blackText,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.order.receiverDetails!.address!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: blackText,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Payment status: ",
                        style: GoogleFonts.roboto(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        capitalizeFirstLetter(widget.order.paymentStatus!),
                        style: GoogleFonts.roboto(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: widget.order.paymentStatus == "paid"
                              ? primaryColor2
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.order.status!.toLowerCase() == "picked"
                      ? "On going".toUpperCase()
                      : widget.order.status!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: switch (widget.order.status!) {
                      'pending' => Colors.orange,
                      'delivered' => Colors.green,
                      'cancelled' => Colors.red,
                      'picked' => primaryColor1,
                      _ => blackText
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "₦${widget.order.price}",
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
