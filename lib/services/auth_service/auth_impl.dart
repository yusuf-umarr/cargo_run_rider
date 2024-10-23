import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/shared_prefs.dart';
import '/models/api_response/error.dart';
import '/models/api_response/success.dart';
import 'auth_service.dart';

String baseUrl = "https://cargo-run-test-31c2cf9f78e4.herokuapp.com/api/v1";

class AuthImpl implements AuthService {
  // String baseUrl = "https://cargo-run-backend.onrender.com/api/v1";

  @override
  Future<Either<ErrorResponse, Success>> login(
      String email, String password) async {
    var url = Uri.parse('$baseUrl/rider/login');
    Map<String, String> body = {"email": email, "password": password};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      debugPrint(response.body);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        sharedPrefs.token = responseBody['data']['token'];
        sharedPrefs.userId = responseBody['data']['_id'];
        sharedPrefs.fullName = responseBody['data']['fullName'];
        sharedPrefs.phone = responseBody['data']['phone'];
        sharedPrefs.email = responseBody['data']['email'];
        sharedPrefs.isLoggedIn = true;
        return Right(Success(message: "Login Successful"));
      } else {
        if (response.statusCode >= 500) {
          return Left(ErrorResponse(error: "Server error"));
        }

        return Left(ErrorResponse(error: responseBody['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> addGuarantor(
      String guarantor1Name,
      String guarantor1Phone,
      String guarantor2Name,
      String guarantor2Phone) async {
    // var url = Uri.parse('$baseUrl/rider/guarantor');
    var url = Uri.parse('$baseUrl/rider');
    var body = {
      "guarantors": {
        "nameOne": guarantor1Name,
        "phoneOne": guarantor1Phone,
        "nameTwo": guarantor2Name,
        "phoneTwo": guarantor2Phone,
      }
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      debugPrint(response.body); //TODO: Remove this line after testing
      if (response.statusCode == 200) {
        return Right(Success(message: "Guarantor Added"));
      } else {
        return Left(ErrorResponse(error: response.body));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> getEmailOTP(String email) async {
    var url = Uri.parse('$baseUrl/rider/resend-otp');
    Map<String, String> body = {"email": email};
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      debugPrint(response.body); //TODO: Remove this line after testing
      if (response.statusCode == 200) {
        return Right(Success(message: "OTP sent to email"));
      } else {
        return Left(ErrorResponse(error: response.body));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> register(
    String fullName,
    String password,
    String phone,
  ) async {
    var url = Uri.parse('$baseUrl/rider');
    Map<String, String> body = {
      "fullName": fullName,
      "password": password,
      "phone": phone
    };
    debugPrint(jsonEncode(body)); //TODO: Remove this line after testing
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      var responseBody = jsonDecode(response.body);
      debugPrint(response.body); //TODO: Remove this line after testing
      if (response.statusCode == 200) {
        sharedPrefs.token = responseBody['token']['token'];
        return Right(Success(message: "Registration Successful"));
      } else {
        if (response.statusCode >= 500) {
          return Left(ErrorResponse(error: "Server error"));
        }
        return Left(ErrorResponse(error: responseBody['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> verifyEmail(
      String email, String otp) async {
    var url = Uri.parse('$baseUrl/rider/verify');
    Map<String, String> body = {"email": email, "otp": otp};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return Right(Success(message: "Email Verified"));
      } else {
        return Left(ErrorResponse(error: response.body));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<ApiRes> getUser() async {
    var url = Uri.parse('$baseUrl/rider');
    String token = sharedPrefs.token;

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonDecode(response.body),
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: false,
        data: e.toString(),
      );
    }
  }

  @override
  Future<ApiRes> updateProfile(
      {required String name,
      required String email,
      required String phone}) async {
    var url = Uri.parse('$baseUrl/rider');
    String token = sharedPrefs.token;

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    Map<String, String> body = {
      "fullName": name,
      "email": email,
      "phone": phone
    };
    try {
      var response = await http.patch(
        url,
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonDecode(response.body),
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return ApiRes(
        statusCode: 500,
        isError: false,
        data: e.toString(),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, Success>> verifyVehicle(
    String driversIdImg,
    String vehicleType,
    String vehicleBrand,
    String vehicleLicensePlate,
  ) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('$baseUrl/rider/vehicle');

    Map<String, String> headers = {"Authorization": "Bearer $token"};
    try {
      var request = http.MultipartRequest('PATCH', url);
      request.fields.addAll({
        "vehicle.vehicleType": vehicleType,
        "vehicle.brand": vehicleBrand,
        "vehicle.plateNumber": vehicleLicensePlate,
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', driversIdImg));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      debugPrint(response.reasonPhrase); //TODO: Remove this line after testing
      if (response.statusCode == 200) {
        return Right(Success(message: "Vehicle Verified"));
      } else {
        return Left(ErrorResponse(error: response.reasonPhrase!));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }
}
