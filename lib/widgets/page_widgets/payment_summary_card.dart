import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';
import '/constants/app_colors.dart';

class PaymentSummaryCard extends StatelessWidget {
  final bool? removeMargin;
    final OrderData order;
  const PaymentSummaryCard({super.key, this.removeMargin,required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: (removeMargin == true)
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          rowItem(title: 'Subtotal', value: '₦ ${order.deliveryFee}'),
          const SizedBox(height: 10.0),
          // rowItem(title: 'Delivery Fee', value: '₦ 180.00'),
          const Divider(
            thickness: 1,
            color: greyText,
          ),
          rowItem(title: 'Discount', value: '₦ 0.00'),
          const SizedBox(height: 10.0),
          rowItem(title: 'Total', value: '₦ ${order.deliveryFee}'),
        ],
      ),
    );
  }

  Widget rowItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
