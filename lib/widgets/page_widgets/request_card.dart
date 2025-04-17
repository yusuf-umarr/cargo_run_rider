// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cargorun_rider/constants/location.dart';
import 'package:cargorun_rider/models/location_model.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '/widgets/app_button.dart';
import 'dart:developer';

class RequestCard extends StatefulWidget {
  final OrderData order;
  final List<OrderData?> orderHistory;
  const RequestCard(
      {super.key, required this.order, required this.orderHistory});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isLoading = false;
  String selectedId = '';
  Timer? _timer;

  _callNumber(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  initState() {
    updateTripLocation();
    postRiderCoordinate(widget.orderHistory);
    super.initState();
  }

  void updateTripLocation() async {
    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        context.read<OrderProvider>().setRiderLocationWithOrderId(
              widget.order.id!,
            );
      });
    }
  }

  void postRiderCoordinate(List<OrderData?> orderHis) {
    for (var order in orderHis) {
      if (order!.status == "picked" ||
          order.status == "accepted" ||
          order.status == "arrived") {
        // log("order status:${order.status}");
        _timer = Timer.periodic(const Duration(minutes: 3), (timer) {
          //get location at every 3mins
          updateTripLocation();
        });
      } else {
        // log("order status is pending----:${order.status}");
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              radius: 20.0,
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
            subtitle: Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'From: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor1),
                      ),
                      TextSpan(
                        text: widget.order.addressDetails!.landMark!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'To: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor1,
                        ),
                      ),
                      TextSpan(
                        text: widget.order.receiverDetails!.address!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _callNumber(widget.order.addressDetails!.contactNumber!);
                  },
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: primaryColor1,
                            size: 15,
                          ),
                          Text(
                            "Sender",
                            style:
                                TextStyle(fontSize: 11.0, color: primaryColor1),
                          ),
                        ],
                      ),
                      Text(
                        widget.order.addressDetails!.contactNumber!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _callNumber(widget.order.receiverDetails!.phone!);
                  },
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: primaryColor1,
                            size: 15,
                          ),
                          Text(
                            "Recipient",
                            style: TextStyle(
                              fontSize: 11.0,
                              color: primaryColor1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.order.receiverDetails!.phone!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Consumer<OrderProvider>(builder: (context, orderVM, _) {
            if (orderVM.acceptStatus == AcceptStatus.loading &&
                selectedId == widget.order.id) {
              return SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.05,
                child: AppButton(
                  text: "Please wait...",
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1,
                  onPressed: () async {},
                  height: 45,
                  textSize: 15,
                ),
              );
            } else {
              return SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.05,
                child: AppButton(
                  text: 'Accept',
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1,
                  onPressed: () async {
                    setState(() {
                      selectedId = widget.order.id!;
                    });

                    final orderVM = context.read<OrderProvider>();
                    await orderVM.setOrder(widget.order);

                    orderVM.postRiderLocationWithOrderId(
                      orderId: widget.order.id!,
                    );

                    await orderVM
                        .acceptRejectOrder(
                      widget.order.id!,
                      'accepted',
                      context,
                    )
                        .then((v) {
                      if (mounted)
                        setState(() {
                          selectedId = "";
                        });
                      if (orderVM.order != null) {
                        if (mounted) {
                          if (orderVM.acceptStatus == AcceptStatus.success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripRoutePage(
                                  order: orderVM.order!,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    });
                  },
                  height: 45,
                  textSize: 15,
                ),
              );
            }
          })
          //
        ],
      ),
    );
  }
}
