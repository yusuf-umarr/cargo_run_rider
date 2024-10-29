import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
  _callNumber(String phone) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
  }

  // int order = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15.0),
      width: size.width,
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
                    : (widget.order.status == 'picked')
                        ? "Riding to Destination"
                        : (widget.order.status == 'arrived')
                            ? "You have arrived at\ndestination point"
                            : " ",
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
          const SizedBox(height: 5.0),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
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
                fontSize: 11.0,
                color: Colors.white,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                _callNumber(widget.order.receiverDetails!.phone!);
              },
              child: Column(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.call,
                          color: primaryColor2,
                        ),
                        Text(
                          "Dial",
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Text(
                    widget.order.receiverDetails!.phone!,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          rowItem(
              title: 'Delivery Fee', value: '₦ ${widget.order.deliveryFee}'),
          const SizedBox(height: 15.0),
          if (widget.order.status == 'accepted') ...[
            const Text(
              "Please click the 'Start' button below once you have picked the package",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Consumer<OrderProvider>(builder: (context, orderVM, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: orderVM.acceptStatus == AcceptStatus.loading
                        ? const LoadingButton(
                            textColor: primaryColor1,
                          )
                        : AppButton(
                            text: 'Start',
                            hasIcon: false,
                            textColor: primaryColor1,
                            onPressed: () async {
                              await orderVM.acceptRejectOrder(
                                widget.order.id!,
                                'picked',
                                context,
                              );
                            },
                            height: 45,
                            textSize: 14,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: orderVM.orderStatus == OrderStatus.loading
                        ? const LoadingButton(
                            backgroundColor: primaryColor2,
                            textColor: Colors.white,
                            height: 45,
                          )
                        : AppButton(
                            text: 'Cancel',
                            hasIcon: false,
                            textColor: Colors.white,
                            backgroundColor: primaryColor2,
                            onPressed: () async {
                              // await context
                              //     .read<OrderProvider>()
                              //     .acceptRejectOrder(
                              //         widget.order.id!, 'cancelled', context);
                            },
                            height: 45,
                            textSize: 14,
                          ),
                  )
                ],
              );
            })
          ],
          if (widget.order.status == 'picked') ...[
            const Text(
              "Please click the 'Notify' button below and contact the recipient once you have arrived at the destination",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Consumer<OrderProvider>(builder: (context, orderVM, _) {
              return Column(
                children: [
                  orderVM.acceptStatus == AcceptStatus.loading
                      ? LoadingButton(
                          backgroundColor: primaryColor2,
                          textColor: Colors.white,
                          width: size.width * 0.6,
                          height: 45,
                        )
                      : AppButton(
                          text: 'Notify',
                          hasIcon: false,
                          textColor: primaryColor2,
                          width: size.width * 0.6,
                          height: 45,
                          textSize: 16,
                          onPressed: () async {
                            await context
                                .read<OrderProvider>()
                                .acceptRejectOrder(
                                    widget.order.id!, 'arrived', context);
                          })
                ],
              );
            })
          ],
          if (widget.order.status == 'arrived') ...[
            const Text(
              "Click the 'Deliver' button below to confirm package delivery.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Consumer<OrderProvider>(builder: (context, orderVM, _) {
              return Column(
                children: [
                  orderVM.acceptStatus == AcceptStatus.loading
                      ? LoadingButton(
                          backgroundColor: primaryColor2,
                          textColor: Colors.white,
                          width: size.width * 0.6,
                          height: 45,
                        )
                      : AppButton(
                          text: 'Deliver',
                          hasIcon: false,
                          textColor: primaryColor2,
                          width: size.width * 0.6,
                          height: 45,
                          textSize: 16,
                          onPressed: () async {
                            await context
                                .read<OrderProvider>()
                                .acceptRejectOrder(
                                    widget.order.id!, 'delivered', context)
                                .then((x) {
                              if (orderVM.acceptStatus ==
                                  AcceptStatus.success) {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            });
                          })
                ],
              );
            })
          ],
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
