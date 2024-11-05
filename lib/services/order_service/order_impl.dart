import 'dart:convert';
import 'dart:developer';

import 'package:cargorun_rider/models/location_model.dart';
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
      // log("other response:${response.body}");
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

  //https://cargo-run-test-31c2cf9f78e4.herokuapp.com/api/v1/order?status=pending
  @override
  Future<Either<ErrorResponse, ApiResponse>> getPendingOrders() async {
    var url = Uri.parse('$baseUrl/order?status=pending');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      // log("other response:${response.body}");
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
  Future<ApiRes> acceptRejectOrder(
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
      final response = await http.patch(
        url,
        headers: headers,
        body: body,
      );
      var jsonResponse = jsonDecode(response.body);
      // log("accept order jsonResponse:$jsonResponse");
      log("accept order jsonResponse:${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonResponse,
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonResponse,
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: true,
        data: e,
      );
    }
  }

  @override
  Future<ApiRes> postRiderLocationWithOrderId(
    String orderId,
    Riderlocation riderlocation,
  ) async {
    var url = Uri.parse('$baseUrl/order/rider-location/$orderId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    var body = jsonEncode({
      "lat": riderlocation.lat,
      "lng": riderlocation.lng,
    });

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: body,
      );
      var jsonResponse = jsonDecode(response.body);

      // log("post-rider-location-status:${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonResponse,
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonResponse,
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: true,
        data: e,
      );
    }
  }

  @override
  Future<ApiRes> getAnalysis() async {
    var url = Uri.parse('$baseUrl/order/analysis');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      var jsonResponse = jsonDecode(response.body);

      // log("ordr-ranalysis:${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonResponse,
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonResponse,
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: true,
        data: e,
      );
    }
  }

  @override
  Future<ApiRes> getNotification() async {
    var url = Uri.parse('$baseUrl/notification?userId=${sharedPrefs.userId}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      var jsonResponse = jsonDecode(response.body);

      // log("ordr-ntif:${jsonResponse}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonResponse,
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonResponse,
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: true,
        data: e,
      );
    }
  }

}
