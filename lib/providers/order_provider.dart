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
  Order? _currentOrder;
  List<Order?> _orders = [];
  List<Order?> _orderHistory = [];

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  List<Order?> get orders => _orders;
  List<Order?> get orderHistory => _orderHistory;
  Order? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;

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
                var fetched = data.map((e) => Order.fromJson(e)).toList();
                _orderHistory = fetched;
                notifyListeners();
              },
            ),
          },
        );
  }

  void acceptRejectOrder(String orderId, String val) async {
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
                  disconnectSocket();
                  // _currentOrder = _orders.firstWhere((element) => element!.orderId == orderId);
                }
              },
            ),
          },
        );
  }

  void socketListener() async {
    io.Socket socket = io.io('wss://cargo-run-backend.onrender.com', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((data) {
      socket.emit(
        'join',
        {"socketId": socket.id!, "userId": sharedPrefs.userId, "type": "Rider"},
      );
      socket.on('join', (data) {});
    });
    socket.on('get-orders', (data) {
      print(data);
      List<dynamic> res = data;
      List<Order?> response = res.map((e) => Order.fromJson(e)).toList();
      _orders = response;
      notifyListeners();
    });
  }

  void disconnectSocket() {
    io.Socket socket = io.io('wss://cargo-run-backend.onrender.com', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.disconnect();
  }
}
