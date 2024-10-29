// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
  bool isLoading = false;
  String selectedId = '';

  _callNumber(String phone) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
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
                          Icon(Icons.phone, color: primaryColor1),
                          Text(
                            "Sender",
                            style:
                                TextStyle(fontSize: 15.0, color: primaryColor1),
                          ),
                        ],
                      ),
                      Text(
                        widget.order.addressDetails!.contactNumber!,
                        style: const TextStyle(
                          fontSize: 13.0,
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
                          Icon(Icons.phone, color: primaryColor1),
                          Text(
                            "Recipient",
                            style:
                                TextStyle(fontSize: 15.0, color: primaryColor1),
                          ),
                        ],
                      ),
                      Text(
                        widget.order.receiverDetails!.phone!,
                        style: const TextStyle(
                          fontSize: 13.0,
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
            return SizedBox(
              width: size.width * 0.4,
              height: size.height * 0.05,
              child: AppButton(
                text: selectedId == widget.order.id!
                    ? "Please wait..."
                    : 'Accept',
                hasIcon: false,
                textColor: Colors.white,
                backgroundColor: primaryColor1,
                onPressed: () async {
                  setState(() {
                    selectedId = widget.order.id!;
                  });

                  await context
                      .read<OrderProvider>()
                      .acceptRejectOrder(
                        widget.order.id!,
                        'accepted',
                        context,
                      )
                      .then((v) {
                    if (orderVM.order != null) {
                      if (mounted) {
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
                  });
                },
                height: 45,
                textSize: 15,
              ),
            );
          })
          //
        ],
      ),
    );
  }
}
