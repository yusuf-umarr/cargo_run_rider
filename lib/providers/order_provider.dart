import 'dart:convert';
import 'dart:developer' as dev;

import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
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

  double riderCurrentLat = 0;
  double riderCurrentLong = 0;
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
      log("catched Error : $e");
    }

    notifyListeners();
  }

  getUpdatedOrder(dynamic order) {
    try {
      _order = OrderData.fromJson(order as Map<String, dynamic>);

      dev.log(
          "_order---single order  --2--: ${_order?.addressDetails?.landMark}");

      notifyListeners();
    } catch (e) {
      log("_order---single error: ${e}");
    }
  }

  setOrder(dynamic order) {
    try {
      _order = order;

      dev.log(
          "_order---single order  --2--: ${_order?.addressDetails?.landMark}");

      notifyListeners();
    } catch (e) {
      log("_order---single error: ${e}");
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

    dev.log("riderCurrentLat:$riderCurrentLat");
    dev.log("riderCurrentLong:$riderCurrentLong");
    dev.log("riderCurrentLong:$riderCurrentLong");

    if (riderCurrentLat != 0) {
      postRiderLocation(orderId);
    }
  }

// emit ('rider-route", {lat, lng, orderId, userId}.
  void postRiderLocation(String iD) {
    dev.log("orderId--  iD-:$iD");
    socketIo.emit(
      'rider-route',
      {
        "lat": riderCurrentLat,
        "lng": riderCurrentLong,
        "orderId": iD,
        "userId": sharedPrefs.userId,
      },
    );

    socketIo!.emit('order');
    log("socketIo---emitting:$socketIo");
  }
  // void setOrder

  Future<void> acceptRejectOrder(String orderId, String val, context) async {
    setAcceptStatus(AcceptStatus.loading);
    var response = await _ordersService.acceptRejectOrder(orderId, val);

    if (response.isError) {
      setAcceptStatus(AcceptStatus.failed);
    } else {
      setAcceptStatus(AcceptStatus.success);
      if (val == "arrived") {
        toast(
            "You have arrived at your destination. Please contact the recipient");
      } else if (val == "picked") {
        toast("You have picked up the package");
      } else {
        toast("Order $val successful");
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (val == "delivered") {
          Navigator.of(context).pop();
        }
      });

      getOrders();

      socketIo!.emit('order');
    }
  }
}
