import 'dart:convert';
import 'dart:developer';

import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/shared_prefs.dart';
import '/services/service_locator.dart';
import '../models/order.dart';
import '../services/order_service/order_service.dart';

enum OrderStatus {
  initial,
  loading,
  pending,
  failed,
  success,
}

class OrderProvider extends ChangeNotifier {
  final OrderService _ordersService = locator<OrderService>();

  OrderStatus _orderStatus = OrderStatus.initial;
  OrderData? _currentOrder;
  List<OrderData?> _orders = [];
  List<OrderData?> _orderHistory = [];
  List<OrderData?> _orderData = [];

  double riderCurrentLat = 0;
  double riderCurrentLong = 0;
  String orderId = '';

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  List<OrderData?> get orders => _orders;
  List<OrderData?> get orderHistory => _orderHistory;
  List<OrderData?> get orderData => _orderData;

  OrderData? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;

  dynamic socketIo;

  setSocketIo(socket) {
    socketIo = socket;

    notifyListeners();
  }

  void setOrderStatus(OrderStatus orderStatus) {
    _orderStatus = orderStatus;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void getOrders() async {
    setOrderStatus(OrderStatus.loading);
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

  void getOrderData(dynamic order) {
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
        notifyListeners();
      } catch (e) {
        log("Error parsing order data: $e");
      }
    } else {
      log("Error: order is not a list");
    }
  }

  void setRiderLocation(
    double lat,
    double long,
    String orderId,
  ) {
    riderCurrentLat = lat;
    riderCurrentLong = long;
    orderId = orderId;
    notifyListeners();

    if (riderCurrentLat != 0) {
      postRiderLocation();
    }
  }

// emit ('rider-route", {lat, lng, orderId, userId}.
  void postRiderLocation() {
    socketIo.emit(
      'rider-route',
      {
        "lat": riderCurrentLat,
        "lng": riderCurrentLong,
        "orderId": orderId,
        "userId": sharedPrefs.userId,
      },
    );
    log("socketIo---emitting:$socketIo");
  }
  // void setOrder

  Future<void> acceptRejectOrder(String orderId, String val) async {
    setOrderStatus(OrderStatus.loading);
    await _ordersService.acceptRejectOrder(orderId, val).then(
          (value) => {
            value.fold(
              (error) {
                setOrderStatus(OrderStatus.failed);
                setErrorMessage(error.error);
              },
              (sucess) {
                setOrderStatus(OrderStatus.success);
                if (val == 'accepted') {
                  // disconnectSocket();
                  // _currentOrder = _orders.firstWhere((element) => element!.orderId == orderId);
                }
              },
            ),
          },
        );
  }

  // void socketListener() async {
  //   io.Socket socket = io.io('wss://cargo-run-backend.onrender.com', {
  //     'transports': ['websocket'],
  //     'autoConnect': true,
  //   });

  //   socket.onConnect((data) {
  //     socket.emit(
  //       'join',
  //       {"socketId": socket.id!, "userId": sharedPrefs.userId, "type": "Rider"},
  //     );
  //     socket.on('join', (data) {});
  //   });
  //   socket.on('get-orders', (data) {
  //     print(data);
  //     List<dynamic> res = data;
  //     List<Order?> response = res.map((e) => Order.fromJson(e)).toList();
  //     _orders = response;
  //     notifyListeners();
  //   });
  // }

  // void disconnectSocket() {
  //   io.Socket socket = io.io('wss://cargo-run-backend.onrender.com', {
  //     'transports': ['websocket'],
  //     'autoConnect': true,
  //   });
  //   socket.disconnect();
  // }
}
