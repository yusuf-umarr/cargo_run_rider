import 'package:cargorun_rider/constants/app_colors.dart';
import 'package:cargorun_rider/models/notification_model.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/notification_detail.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:cargorun_rider/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).getNotification();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final orderVM = context.watch<OrderProvider>();
    return Scaffold(
      appBar: appBarWidget(context, title: 'Notifications'),
      body: Center(
          child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20),
        itemCount: orderVM.notificationModel.length,
        itemBuilder: (context, index) {
          if (orderVM.notificationModel.isNotEmpty) {
            orderVM.notificationModel.sort((a, b) =>
                DateTime.parse(b.createdAt!)
                    .compareTo(DateTime.parse(a.createdAt!)));

            final NotificationData notification =
                orderVM.notificationModel[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationDetail(
                              notification: notification,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor1.withOpacity(0.1)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Image.asset(
                    "assets/images/logo.png",
                    height: size.height * 0.02,
                  ),
                  title: Text(
                    notification.message!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        formatDate(notification.createdAt!),
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                      Text(
                        formatTime(notification.createdAt!),
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/notifications.png',
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'You have no notifications\nto display',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
