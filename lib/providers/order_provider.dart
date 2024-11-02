import 'dart:developer' as dev;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cargorun_rider/models/location_model.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:math';

import '/services/service_locator.dart';
import '../services/order_service/order_service.dart';

enum OrderStatus {
  initial,
  loading,
  pending,
  failed,
  success,
}

enum AcceptStatus {
  initial,
  loading,
  pending,
  failed,
  success,
}

class OrderProvider extends ChangeNotifier {
  final OrderService _ordersService = locator<OrderService>();

  OrderStatus _orderStatus = OrderStatus.initial;
  AcceptStatus _acceptStatus = AcceptStatus.initial;
  OrderData? _currentOrder;
  List<OrderData?> _orders = [];

  List<OrderData?> _orderHistory = [];

  List<OrderData?> _orderData = [];

  OrderData? _order;

  List lastOrderTime = [0, 0];

  static const double earthRadiusKm = 6371.0;

  double riderCurrentLat = 0;
  double riderCurrentLong = 0;
  String currentOrderId = '';
  String orderId = '';

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  List<OrderData?> get orders => _orders;
  List<OrderData?> get orderHistory => _orderHistory;
  List<OrderData?> get orderData => _orderData;
  OrderData? get order => _order;

  OrderData? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;
  AcceptStatus get acceptStatus => _acceptStatus;

  Riderlocation? _riderlocation;
  Riderlocation? get riderlocation => _riderlocation;

  dynamic socketIo;

  setSocketIo(socket) {
    socketIo = socket;

    notifyListeners();
  }

  void setOrderStatus(OrderStatus orderStatus) {
    _orderStatus = orderStatus;
    notifyListeners();
  }

  void setAcceptStatus(AcceptStatus acceptStatus) {
    _acceptStatus = acceptStatus;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void getOrdersHistory() async {
    await _ordersService.getOrders().then(
          (value) => {
            value.fold(
              (error) {
                setOrderStatus(OrderStatus.failed);
                _orderHistory = [];
              },
              (sucess) {
                setOrderStatus(OrderStatus.success);
                List<dynamic> data = sucess.data;
                var fetched = data.map((e) => OrderData.fromJson(e)).toList();
                _orderHistory = fetched;
                notifyListeners();
              },
            ),
          },
        );
  }

  void getPendingOrders() async {
    await _ordersService.getPendingOrders().then(
          (value) => {
            value.fold(
              (error) {
                setOrderStatus(OrderStatus.failed);
              },
              (sucess) {
                setOrderStatus(OrderStatus.success);
                List<dynamic> data = sucess.data;
                var fetched = data.map((e) => OrderData.fromJson(e)).toList();
                _orderData = fetched;
                notifyListeners();
              },
            ),
          },
        );
  }

  void getOrderData(dynamic order) {
    try {
      if (order is List) {
        try {
          _orderData = order.map((e) {
            if (e is Map<String, dynamic>) {
              return OrderData.fromJson(e);
            } else {
              log("Unexpected data type: ${e.runtimeType} - $e");
              throw Exception('Invalid data format: ${e.runtimeType}');
            }
          }).toList();
          // log("_orderData: $_orderData");
        } catch (e) {
          log("Error parsing order data: $e");
        }
      } else {}
    } catch (e) {
      log("catched Error  getOrderData: $e");
    }

    notifyListeners();
  }

  bool getNewOrder({dynamic order}) {
    try {
      if (order is List) {
        List<OrderData> newOrder = order.map((e) {
          if (e is Map<String, dynamic>) {
            return OrderData.fromJson(e);
          } else {
            log("Unexpected data type: ${e.runtimeType} - $e");
            throw Exception('Invalid data format: ${e.runtimeType}');
          }
        }).toList();

        newOrder.sort((a, b) => DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!)));

        OrderData firstOder = _orderData.first!;

        dev.log("firstOder:${firstOder.receiverDetails!.name!}");

        return calculateDistance(
          packageLat: firstOder.addressDetails!.lat!,
          packageLng: firstOder.addressDetails!.lng!,
          riderLat: riderCurrentLat,
          riderLng: riderCurrentLong,
        );

        // log("firstOder time : $firstOder");
      } else {
        dev.log("order is not list=======");
        return false;
      }
    } catch (e) {
      dev.log("catched Error  getNewOrder: $e");
      return false;
    }
  }

  // Method to calculate the distance in kilometers
  bool calculateDistance({
    required double riderLat,
    required double riderLng,
    required double packageLat,
    required double packageLng,
  }) {
    double totalDistance = 0;
    // Convert latitude and longitude from degrees to radians
    final double riderLatRad = _toRadians(riderLat);
    final double riderLngRad = _toRadians(riderLng);
    final double packageLatRad = _toRadians(packageLat);
    final double packageLngRad = _toRadians(packageLng);

    // Haversine formula
    final double dLat = packageLatRad - riderLatRad;
    final double dLng = packageLngRad - riderLngRad;

    final double a = pow(sin(dLat / 2), 2) +
        cos(riderLatRad) * cos(packageLatRad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    totalDistance = earthRadiusKm * c;
    dev.log("totalDistance:$totalDistance");

    if (totalDistance <= 10) {
      dev.log("totalDistance:$totalDistance and less than 5km");
      // Future.delayed(const Duration(milliseconds: 100), () {
      //   newOrderNotify();
      // });
      return true;
    } else {
      dev.log("totalDistance:$totalDistance and more than 5km");
      return false;
    }

    // if (totalDistance <= ) {
    //isNewOrder

    // }
  }

  newOrderNotify() async {
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
  }

  // Helper method to convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  getUpdatedOrder(dynamic order) {
    try {
      _order = OrderData.fromJson(order as Map<String, dynamic>);

      notifyListeners();
    } catch (e) {
      log("_order---single error: $e");
    }
  }

  setOrder(dynamic order) {
    try {
      _order = order;
      notifyListeners();
    } catch (e) {
      log("_order---single error: $e");
    }
  }

  void setRiderLocationWithOrderId(
    double lat,
    double long,
    String orderId,
  ) {
    riderCurrentLat = lat;
    riderCurrentLong = long;
    currentOrderId = orderId;

    _riderlocation = Riderlocation(lng: long, lat: lat);
    notifyListeners();

    // dev.log("_riderlocation:$_riderlocation");

    if (_riderlocation != null) {
      postRiderLocationWithOrderId();
    }
  }

  Future<void> postRiderLocationWithOrderId() async {
    try {
      var response = await _ordersService.postRiderLocationWithOrderId(
        currentOrderId,
        riderlocation!, //Riderlocation
      );
      if (response.isError) {
      } else {}
    } catch (e) {
      dev.log("catch update error:$e");
    }
  }

  setLocationCoordinate(
    double lat,
    double long,
  ) {
    riderCurrentLat = lat;
    riderCurrentLong = long;
    _riderlocation = Riderlocation(lng: long, lat: lat);

    notifyListeners();
  }

  void disconnect() {
    socketIo.disconnect();
  }

  void reconnect() {
    socketIo.connect();
  }

  Future<void> acceptRejectOrder(String orderId, String val, context) async {
    dev.log("acceptRejectOrderacceptRejectOrder cliked==");
    setAcceptStatus(AcceptStatus.loading);

    try {
      var response = await _ordersService.acceptRejectOrder(orderId, val);
      if (response.isError) {
        setAcceptStatus(AcceptStatus.failed);
      } else {
        getUpdatedOrder(response.data['data']);
        setAcceptStatus(AcceptStatus.success);
        if (val == "arrived") {
          toast(
              "You have arrived at your destination. Please contact the recipient");
        } else if (val == "picked") {
          toast("You have picked up the package");
        } else {
          toast("Order $val successful");
        }

        getPendingOrders();

        getOrdersHistory();

        socketIo!.emit('order');
      }
    } catch (e) {
      dev.log("catch update error:$e");
    }
  }
}
