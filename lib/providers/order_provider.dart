import 'dart:developer' as dev;

import 'package:cargorun_rider/models/location_model.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
      log("catched Error : $e");
    }
    getOrderDat();

    notifyListeners();
  }

  void getOrderDat() {
    try {
      _orderData.sort((a, b) => DateTime.parse(b!.createdAt!)
          .compareTo(DateTime.parse(a!.createdAt!)));

      var firstOder = _orderData.first!.createdAt!;
      compareWithCurrentTime(firstOder);

      // log("firstOder time : $firstOder");
    } catch (e) {
      log("catched Error : $e");
    }

    notifyListeners();
  }

  List lastOrderTime =[0,0];

  void compareWithCurrentTime(String givenTime) {
    // Parse the given time string to a DateTime object
    DateTime parsedTime = DateTime.parse(givenTime);

    // Get the current time
    DateTime currentTime = DateTime.now();

    // Compare the parsed time with the current time
    Duration difference = currentTime.difference(parsedTime);

    if (difference.isNegative) {
      dev.log('The given time is in the future.');
    } else if (difference.inSeconds == 0) {
      dev.log('The given time is exactly the current time.');
    } else {
      dev.log(
          'The given time was ${difference.inMinutes} min. ago $givenTime.');

          if (lastOrderTime[0]==0) {
            lastOrderTime[0]= difference.inSeconds;
            //notify
            
          }else{
             lastOrderTime[1]= difference.inSeconds;
             //notify
          }

    }
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
    _riderlocation = Riderlocation(lng: long, lat: lat);

    if (_riderlocation != null && socketIo != null) {
      socketIo.emit('pendingOrder', {
        "lng": _riderlocation!.lng.toString(),
        "lat": _riderlocation!.lat.toString(),
      });
      // dev.log("done===$long $long=");
    }
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
