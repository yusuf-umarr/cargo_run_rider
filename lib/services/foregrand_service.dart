import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  io.Socket socket = io.io(
      'https://cargo-run-test-31c2cf9f78e4.herokuapp.com',
      io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect() // disable auto-connection
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build());
  socket.connect();
  socket.onConnect((_) {
    log('Connected. Socket ID: ${socket.id}');
    // Implement your socket logic here
    // For example, you can listen for events or send data
  });

  socket.on('new-order', (data) async {
    // Provider.of<OrderProvider>(context, listen: false).getPendingOrders();

    await NotificationService.showNotification(
        title: "New order",
        body: "new order has been created",
        payload: {
          "navigate": "true",
        },
        actionButtons: [
          NotificationActionButton(
            key: 'Preview',
            label: 'Preview',
            actionType: ActionType.Default,
            color: Colors.green,
          )
        ]);
  });

  socket.onDisconnect((_) {
    log('Disconnected');
  });
  socket.on("event", (data) {
    //do something here
  });
  service.on("stop").listen((event) {
    service.stopSelf();
    log("background process is now stopped");
  });

  service.on("start").listen((event) {});

  // Timer.periodic(const Duration(minutes: 5), (timer) {
  //   socket.emit("backgroundmain", " ${DateTime.now().second}");
  //   log("service is successfully running ${DateTime.now().second}");
  // });

}


