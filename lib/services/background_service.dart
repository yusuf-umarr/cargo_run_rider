import 'dart:ui';
import 'package:cargorun_rider/services/auth_service/auth_impl.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:developer' as dev;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void initializeService(
//     String orderId, String userId, String orderStatus) async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//     ),
//     iosConfiguration: IosConfiguration(),
//   );

//   service.startService();
//   service.invoke("setIds", {
//     "orderId": orderId,
//     "userId": userId,
//     "orderStatus": orderStatus,
//   });
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   io.Socket socket = io.io(baseUrlSocket, <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': true,
//     'forceNew': true,
//   });

//   socket.connect();

//   String? orderId;
//   String? userId;
//   String? orderStatus;

//   service.on("setIds").listen((event) {
//     orderId = event!["orderId"];
//     userId = event["userId"];
//     orderStatus = event["orderStatus"];
//   });

//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService();
//   }

//   const LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 10,
//   );

//   Geolocator.getPositionStream(locationSettings: locationSettings)
//       .listen((Position position) {
//     log("Background Location: ${position.latitude}, ${position.longitude}");

//     if (orderId != null && userId != null && socket.connected) {
//       if (orderStatus == "picked" ||
//           orderStatus == "accepted" ||
//           orderStatus == "arrived") {
//         socket.emit("rider-location", {
//           "lat": position.latitude,
//           "lng": position.longitude,
//           "orderId": orderId,
//           "userId": userId,
//         });
//       }
//     }
//   });
//   socket.onAny(
//     (event, data) {
//       log("event in server:$event, data in service:$data");
//     },
//   );
// }





// DO NOT import flutter_background_service_android or UI-based plugins here

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   String? orderId;
//   String? userId;
//   String? orderStatus;

//   late io.Socket socket;

//   void connectSocket() {
//     socket = io.io(baseUrlSocket, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//       'forceNew': true,
//     });

//     socket.onConnect((_) {
//       log('[BackgroundService] Socket connected');
//     });

//     socket.onDisconnect((_) {
//       log('[BackgroundService] Socket disconnected');
//     });

//     socket.onAny((event, data) {
//       log('[Socket] $event => $data');
//     });
//   }

//   connectSocket();

//   service.on("setIds").listen((event) {
//     orderId = event!["orderId"];
//     userId = event["userId"];
//     orderStatus = event["orderStatus"];
//   });

//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService();
//   }

//   const LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 10,
//   );

//   Geolocator.getPositionStream(locationSettings: locationSettings)
//       .listen((Position position) {
//     log("📍 [BG Location] ${position.latitude}, ${position.longitude}");

//     if (socket.connected && orderId != null && userId != null) {
//       if (orderStatus == "picked" ||
//           orderStatus == "accepted" ||
//           orderStatus == "arrived") {
//         socket.emit("rider-location", {
//           "lat": position.latitude,
//           "lng": position.longitude,
//           "orderId": orderId,
//           "userId": userId,
//         });
//       }
//       dev.log("socket--here:${socket}");
//     }
//   });
// }




@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();

  String? orderId;
  String? userId;
  String? orderStatus;

  final socket = io.io(baseUrlSocket, {
    'transports': ['websocket'],
    'autoConnect': true,
    'forceNew': true,
  });

  socket.connect();

  service.on("setIds").listen((event) {
    orderId = event!["orderId"];
    userId = event["userId"];
    orderStatus = event["orderStatus"];
  });

  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position position) {
      dev.  log("Background Location: ${position.latitude}, ${position.longitude}");
      if (orderId != null &&
          userId != null &&
          socket.connected &&
          ["accepted", "picked", "arrived"]
              .contains(orderStatus?.toLowerCase())) {
        socket.emit("rider-location", {
          "lat": position.latitude,
          "lng": position.longitude,
          "orderId": orderId,
          "userId": userId,
        });

        dev.log("socket--here:${socket}");
      }
    },
  );
}
