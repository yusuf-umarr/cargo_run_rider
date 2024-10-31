import 'dart:async';
import 'dart:developer';
import 'package:cargorun_rider/constants/location.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Timer? _timer;

  @override
  initState() {
    getLocation();
    _startCounter();

    super.initState();
  }

  void getLocation() async {
    Position position = await determinePosition();
    if (mounted) {
      context.read<OrderProvider>().setRiderLocationWithOrderId(
            position.latitude,
            position.latitude,
            widget.order.id!,
          );
    }
  }

  void _startCounter() {
    if (widget.order.status == 'picked' ||
        widget.order.status == 'accepted' ||
        widget.order.status == 'arrived') {
      log("order status is ====:${widget.order.status}");
      _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
        getLocation();
      });
    } else {
      // log("order is pending==== or delivered");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.order.status == "accepted" ||
            widget.order.status == "pending" ||
            widget.order.status == 'picked' ||
            widget.order.status == 'arrived') {
          // var _order = OrderData(
          //   addressDetails: order.addressDetails,
          //   receiverDetails: order.receiverDetails,
          //   id: order.id,
          //   orderId: order.orderId,
          //   trackingId: order.trackingId,
          //   amount: order.amount,
          //   userId: order.userId,
          //   status: order.status,
          //   paymentStatus: order.paymentStatus,
          //   deliveryService: order.deliveryService,
          //   deliveryOption: order.deliveryOption,
          //   averageRating: order.averageRating,
          //   deliveryFee: order.deliveryFee,
          //   isDelete: order.isDelete,
          //   ratings: order.ratings,
          //   createdAt: order.createdAt,
          //   updatedAt: order.updatedAt,
          //   v: order.v,
          // );

          await context.read<OrderProvider>().setOrder(widget.order);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripRoutePage(
                order: widget.order,
              ),
            ),
          );
        }

        if (widget.order.status == "delivered") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShipmentDetailsScreen(order: widget.order),
            ),
          );
        }
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
                  "₦${widget.order.deliveryFee}",
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
