import 'package:cargorun_rider/models/notification_model.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:flutter/material.dart';

class NotificationDetail extends StatelessWidget {
  final NotificationData notification;
  const NotificationDetail({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: size.height * 0.1,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              notification.message!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDate(notification.createdAt!),
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                const Text(" - "),
                Text(
                  formatTime(notification.createdAt!),
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
