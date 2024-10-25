import 'dart:developer';

import 'package:cargorun_rider/constants/location.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '/widgets/app_button.dart';

class RequestCard extends StatefulWidget {
  final OrderData order;
  const RequestCard({super.key, required this.order});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  double riderLat = 0;
  double riderLong = 0;
  void getLocation() async {
    log("getLocation===========getLocation====called");
    Position position = await determinePosition();
    debugPrint('position: $position');
    if (mounted) {
      context.read<OrderProvider>().setRiderLocation(
            position.latitude,
            position.latitude,
            widget.order.orderId!,
          );
    }

    // context.read<OrderProvider>().riderCurrentLong = position.latitude;
    // context.read<OrderProvider>().orderId = widget.order.orderId!;
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

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
                  widget.order.receiverDetails!.name![0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.order.receiverDetails!.name!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: blackText.withOpacity(0.9),
              ),
            ),
            subtitle: Text(
              widget.order.receiverDetails!.address!,
              style: const TextStyle(
                fontSize: 15.0,
                color: greyText,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<OrderProvider>(builder: (context, orderVM, _) {
                if (orderVM.orderStatus == OrderStatus.loading) {
                  return SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.05,
                      child: const LoadingButton(  textColor: Colors.white,
                        backgroundColor: primaryColor1,));
                }
                return SizedBox(
                  width: size.width * 0.4,
                  height: size.height * 0.05,
                  child: AppButton(
                    text: 'Accept',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () async {
                      log("accepted=====");
                      await context
                          .read<OrderProvider>()
                          .acceptRejectOrder(
                            widget.order.id!,
                            'accepted',
                            context,
                          )
                          .then((v) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripRoutePage(
                                    order: widget.order,
                                  ),
                                ),
                              ));

                      /*
                             .then((x) => 
                            */
                    },
                    height: 45,
                    textSize: 15,
                  ),
                );
              }),
            ],
          )
          //
        ],
      ),
    );
  }
}
