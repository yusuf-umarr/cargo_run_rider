// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:another_stepper/another_stepper.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargorun_rider/services/background_service.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:cargorun_rider/widgets/page_widgets/delivery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/page_widgets/appbar_widget.dart';
import '../../../widgets/page_widgets/payment_summary_card.dart';

class ShipmentDetailsScreen extends StatefulWidget {
  const ShipmentDetailsScreen({
    super.key,
  });

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  List<StepperData> stepperData = [];
  StreamSubscription<Position>? positionStream;

  void initializeServiceIOS() async {
    final orderVM = context.read<OrderProvider>();

    // LocationPermission permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   debugPrint("Location permission denied.");
    //   return;
    // }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      orderVM.getRiderLocationCoordinate(
          lat: position.latitude,
          long: position.longitude,
          orderId: orderVM.order!.id!,
          userId: orderVM.order!.userId!["_id"]);
      log("Sending location: ${position.latitude}, ${position.longitude}");
    });
  }

  void startLocationTracking() async {
    final orderVM = context.read<OrderProvider>();
    if (orderVM.order!.status!.toLowerCase() == "accepted" ||
        orderVM.order!.status!.toLowerCase() == "picked" ||
        orderVM.order!.status!.toLowerCase() == "arrived") {
      log("order status 1:${orderVM.order!.status!.toLowerCase()}");

      if (Platform.isAndroid) {
        initializeServiceAndroid(
          orderVM.order!.id!,
          orderVM.order!.userId!["_id"],
          orderVM.order!.status!,
        );
      } else if (Platform.isIOS) {
        initializeServiceIOS();
      }
    } else {
      log("order status. 2:${orderVM.order!.status!.toLowerCase()}");
    }
  }

  @override
  void initState() {
    startLocationTracking();

    super.initState();
  }

  void initializeServiceAndroid(
    String orderId,
    String userId,
    String orderStatus,
  ) async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
      ),
      iosConfiguration: IosConfiguration(),
    );

    await service.startService();
    service.invoke("setIds", {
      "orderId": orderId,
      "userId": userId,
      "orderStatus": orderStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderVM = context.watch<OrderProvider>();

    stepperData = [
      StepperData(
        title: StepperText(
          orderVM.order!.addressDetails!.landMark!,
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: greyText,
            decorationThickness: 0.5,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: primaryColor1,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: const Icon(Icons.looks_one, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          orderVM.order!.receiverDetails!.address!,
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: greyText,
            decorationThickness: 0.5,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: primaryColor2,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: const Icon(Icons.looks_two, color: Colors.white),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: appBarWidget(context, title: 'Order history', hasBackBtn: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Order: ',
                      style: const TextStyle(
                        color: blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: orderVM.order!.orderId,
                          style: const TextStyle(
                            color: primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0)
                      .copyWith(top: 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Order status: ',
                      style: const TextStyle(
                        color: blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: capitalizeFirstLetter(orderVM.order!.status!),
                          style: const TextStyle(
                            color: primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  log("oderid:${orderVM.order!.id!}");
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0)
                        .copyWith(top: 10),
                    child: RichText(
                      text: TextSpan(
                        text: 'Payment status: ',
                        style: const TextStyle(
                          color: blackText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: capitalizeFirstLetter(
                                orderVM.order!.paymentStatus!),
                            style: const TextStyle(
                              color: primaryColor2,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5,
                  ),
                  child: AnotherStepper(
                    stepperList: stepperData,
                    stepperDirection: Axis.vertical,
                  ),
                ),
                if (orderVM.order!.status == "delivered") ...[
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: AppButton(
                  //     text: 'Get help with ride',
                  //     hasIcon: false,
                  //     textColor: Colors.white,
                  //     backgroundColor: primaryColor1.withOpacity(0.7),
                  //   ),
                  // ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<OrderProvider>()
                              .setOrder(orderVM.order);
                          showModalBottomSheet(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                final orderVM = context.watch<OrderProvider>();

                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.6,
                                    child: Stack(
                                      children: [
                                        DeliveryCard(
                                          order: orderVM.order!,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text("Update order"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<OrderProvider>()
                              .setOrder(orderVM.order);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripRoutePage(
                                order: orderVM.order!,
                              ),
                            ),
                          );
                        },
                        child: const Text("View route"),
                      ),
                    ],
                  )
                ],
                PaymentSummaryCard(
                  order: orderVM.order!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
