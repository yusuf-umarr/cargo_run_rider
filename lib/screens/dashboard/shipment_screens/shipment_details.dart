import 'package:another_stepper/another_stepper.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/page_widgets/appbar_widget.dart';
import '../../../widgets/page_widgets/payment_summary_card.dart';

class ShipmentDetailsScreen extends StatefulWidget {
  final OrderData order;

  const ShipmentDetailsScreen({super.key, required this.order});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  List<StepperData> stepperData = [];

  @override
  void initState() {
    stepperData = [
      StepperData(
        title: StepperText(
          widget.order.addressDetails!.landMark!,
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
          widget.order.receiverDetails!.address!,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          text: widget.order.orderId,
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
                    text: const TextSpan(
                      text: 'Status: ',
                      style: TextStyle(
                        color: blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: "Delivered",
                          style: TextStyle(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5,
                  ),
                  child: AnotherStepper(
                    stepperList: stepperData,
                    stepperDirection: Axis.vertical,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: AppButton(
                    text: 'Get help with ride',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1.withOpacity(0.7),
                  ),
                ),
                PaymentSummaryCard(
                  order: widget.order,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
