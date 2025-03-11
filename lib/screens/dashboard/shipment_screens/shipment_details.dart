// ignore_for_file: use_build_context_synchronously

import 'package:another_stepper/another_stepper.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:cargorun_rider/widgets/page_widgets/delivery_card.dart';
import 'package:flutter/material.dart';
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
                Padding(
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
                ),
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
                                    heightFactor: 0.54,
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
