import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_colors.dart';
import '../app_button.dart';

class DeliveryCard extends StatefulWidget {
  final OrderData order;

  const DeliveryCard({
    super.key,
    required this.order,
  });

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  // int order = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: primaryColor1,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                (widget.order.status == "accepted")
                    ? "You're a few minutes away"
                    : (widget.order.status == 'on-going')
                        ? "Riding to Destination"
                        : "You have arrived at destination point ",
                style: const TextStyle(
                  fontSize: 9.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Order ID', value: '${widget.order.orderId}'),
          const SizedBox(height: 10.0),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
            // leading: Image.asset(
            //   'assets/images/pp.png',
            //   height: 40,
            // ),
            title: Text(
              widget.order.receiverDetails!.name!,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              widget.order.receiverDetails!.address!,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
            trailing: const SizedBox(
              width: 58,
              child: Row(
                children: [
                  Icon(Iconsax.call, color: primaryColor2),
                  SizedBox(width: 10),
                  Icon(Iconsax.message, color: primaryColor2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          rowItem(
              title: 'Delivery Fee', value: '₦ ${widget.order.deliveryFee}'),
          const SizedBox(height: 25.0),
          if (widget.order.status == 'on-going') ...[
            AppButton(
              text: 'Cancel Request',
              hasIcon: false,
              width: size.width * 0.6,
              height: 45,
              textSize: 16,
              onPressed: () {
                setState(() {
                  // order = 2;
                });
              },
            )
          ],
          if (widget.order.status == 'accepted') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Start',
                    hasIcon: false,
                    textColor: primaryColor1,
                    onPressed: () {
                      setState(() {
                        // order = 3;
                      });
                    },
                    height: 45,
                    textSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor2,
                    onPressed: () {
                      setState(() {
                        // order = 1;
                      });
                    },
                    height: 45,
                    textSize: 14,
                  ),
                )
              ],
            )
          ],
          if (widget.order.status == 'successful')
            AppButton(
              text: 'Package Delivered',
              hasIcon: false,
              textColor: primaryColor2,
              width: size.width * 0.6,
              height: 45,
              textSize: 16,
              onPressed: () => Navigator.pop(context),
            )
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
          style: GoogleFonts.roboto(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: primaryColor2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
