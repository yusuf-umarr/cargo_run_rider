import 'dart:convert';
import 'dart:developer';

import 'package:cargorun_rider/services/auth_service/auth_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../constants/shared_prefs.dart';
import '../../models/api_response/error.dart';
import '../../models/api_response/success.dart';
import 'order_service.dart';

class OrderImpl implements OrderService {
  // String baseUrl = "https://cargo-run-backend.onrender.com/api/v1";
  @override
  Future<Either<ErrorResponse, ApiResponse>> getOrders() async {
    var url = Uri.parse('$baseUrl/order?riderId=${sharedPrefs.userId}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      log("other response:${response.body}");
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(error: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(error: 'Error: $e'));
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> acceptRejectOrder(
    String orderId,
    String value,
  ) async {
    var url = Uri.parse('$baseUrl/order/$orderId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    var body = jsonEncode({"status": value});

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return Right(Success.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(error: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(error: 'Error: $e'));
    }
  }
}
