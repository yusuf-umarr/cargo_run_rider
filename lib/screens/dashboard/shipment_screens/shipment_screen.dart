import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/page_widgets/appbar_widget.dart';
import '../../../widgets/page_widgets/shipment_card.dart';

class ShipmentScreen extends StatefulWidget {
  const ShipmentScreen({super.key});

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: appBarWidget(context, title: 'Order History', isBack: false),
      body: Consumer<OrderProvider>(
        builder: (context, watch, _) {
          if (watch.orderStatus == OrderStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor1),
              ),
            );
          }
          if (watch.orderHistory.isEmpty) {
            return const Center(
              child: Text(
                'No Order History',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: List.generate(
                        watch.orderHistory.length,
                        (i) => ShipmentCard(order: watch.orderHistory[i]!),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
