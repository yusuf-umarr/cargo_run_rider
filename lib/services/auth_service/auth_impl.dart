import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/shared_prefs.dart';
import '/models/api_response/error.dart';
import '/models/api_response/success.dart';
import 'auth_service.dart';

// String baseUrl = "https://cargo-run-test-31c2cf9f78e4.herokuapp.com/api/v1";
String baseUrl = "https://cargo-run-d699d9f38fb5.herokuapp.com/api/v1";

class AuthImpl implements AuthService {
  // String baseUrl = "https://cargo-run-backend.onrender.com/api/v1";

  // @override
  // Future<Either<ErrorResponse, Success>> login(
  //     String email, String password) async {
  //   var url = Uri.parse('$baseUrl/rider/login');
  //   Map<String, String> body = {"email": email, "password": password};
  //   Map<String, String> headers = {"Content-Type": "application/json"};
  //   try {
  //     var response =
  //         await http.post(url, body: jsonEncode(body), headers: headers);
  //     debugPrint(response.body);
  //     var responseBody = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       sharedPrefs.token = responseBody['data']['token'];
  //       sharedPrefs.userId = responseBody['data']['_id'];
  //       sharedPrefs.fullName = responseBody['data']['fullName'];
  //       sharedPrefs.phone = responseBody['data']['phone'];
  //       sharedPrefs.email = responseBody['data']['email'];
  //       sharedPrefs.isLoggedIn = true;
  //       return Right(Success(message: "Login Successful"));
  //     } else {
  //       if (response.statusCode >= 500) {
  //         dev.log("error here:${responseBody}");
  //         return Left(ErrorResponse(error: "Network error"));
  //       }

  //       return Left(ErrorResponse(error: responseBody));
  //     }
  //   } catch (e) {
  //     return Left(ErrorResponse(error: "Network error"));
  //   }
  // }

  @override
  Future<Either<ErrorResponse, Success>> addGuarantor(
      String guarantor1Name,
      String guarantor1Phone,
      String guarantor2Name,
      String guarantor2Phone) async {
    // var url = Uri.parse('$baseUrl/rider/guarantor');
    String userId = sharedPrefs.userId;
    var url = Uri.parse('$baseUrl/rider/$userId');

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
      // 'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      var responseBody = jsonDecode(response.body);

      dev.log("guarantor res$responseBody");
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
    dev.log("get otp:$email");
    Map<String, String> body = {"email": email};
    Map<String, String> headers = {
      "Content-Type": "application/json",
      // 'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      dev.log("get otp res:${jsonDecode(response.body)}");
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
  Future<ApiRes> register(
    String fullName,
    String email,
    String password,
    String phone,
  ) async {
    var url = Uri.parse('$baseUrl/rider');
    Map<String, String> body = {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phone": phone
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // dev.log("register res id:${responseBody['data']['_id']}");
        sharedPrefs.userId = responseBody['data']['_id'];
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
  Future<ApiRes> login(
    String email,
    String password,
  ) async {
    var url = Uri.parse('$baseUrl/rider/login');
    Map<String, String> body = {
      "email": email,
      "password": password,
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sharedPrefs.token = responseBody['data']['token'];
        sharedPrefs.userId = responseBody['data']['_id'];
        sharedPrefs.fullName = responseBody['data']['fullName'];
        sharedPrefs.phone = responseBody['data']['phone'];
        sharedPrefs.email = responseBody['data']['email'];
        sharedPrefs.isLoggedIn = true;
        return ApiRes(
          statusCode: response.statusCode,
          isError: false,
          data: jsonDecode(response.body),
        );
      } else {
        return ApiRes(
          statusCode: response.statusCode,
          isError: true,
          data: "Network error",
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
  Future<Either<ErrorResponse, Success>> verifyEmail(
      String email, String otp) async {
    dev.log("is email:$email");
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
      var responseBody = jsonDecode(response.body);

      dev.log("verify email res$responseBody");
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
        data: "Network error",
      );
    }
  }

  @override
  Future<ApiRes> updateProfile(
      {required String name,
      required String email,
      required String phone}) async {
    var url = Uri.parse('$baseUrl/rider/${sharedPrefs.userId}');
    String token = sharedPrefs.token;

    Map<String, String> headers = {
      // "Content-Type": "application/json",
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

      dev.log("update res: ${response.body}");
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
    // String token = sharedPrefs.token;
    String userId = sharedPrefs.userId;
    var url = Uri.parse('$baseUrl/rider/vehicle/$userId');

    dev.log("userId:$userId");

    // Map<String, String> headers = {"Authorization": "Bearer $token"};
    try {
      var request = http.MultipartRequest('PATCH', url);
      request.fields.addAll({
        "vehicle.vehicleType": vehicleType,
        "vehicle.brand": vehicleBrand,
        "vehicle.plateNumber": vehicleLicensePlate,
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', driversIdImg));
      // request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return Right(Success(message: "Vehicle Verified"));
      } else {
        log("response:${response.reasonPhrase}");
        return Left(ErrorResponse(error: response.reasonPhrase!));
      }
    } catch (e) {
      return Left(ErrorResponse(error: e.toString()));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> resetPassword({
    required String otp,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'email': sharedPrefs.email,
      'newPassword': password,
      'otp': otp,
    };
    // final Map<String, String> headers = {'Content-Type': 'application/json'};
    String responseBody;
    log("reset-sharedPrefs.email:${sharedPrefs.email}");
    log("reset-otp:$otp}");
    log("reset-pass:$password}");
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/rider/reset-password'),
        body: body,
        // headers: headers,
      );
      responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      log("reset-pass=======jsonResponse:$jsonResponse");
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
  Future<Either<ErrorResponse, ApiResponse>> forgotPassword(
      {required String email}) async {
    final Map<String, dynamic> body = {
      'email': email,
    };
    // final Map<String, String> headers = {'Content-Type': 'application/json'};
    String responseBody;

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/rider/forgot-password'),
        body: body,
        // headers: headers,
      );
      responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      log("forgot pass jsonResponse:$jsonResponse");
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(error: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(error: 'Error: $e'));
    }
  }
}
