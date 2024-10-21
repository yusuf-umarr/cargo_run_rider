import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/services/auth_service/auth_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthTokenProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  Future<Map<String, dynamic>> validateToken() async {
    var url = Uri.parse("${baseUrl}/rider");

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${sharedPrefs.token}"
    };
  
    //  log("response:${response.body}");

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      log("response:${response.statusCode}");

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);

        return {
          "res": true,
        }; // Token is valid
      } else {
        return {"res": false};
      }
    } catch (e) {
      debugPrint('Error validating token: $e');
      return {
        "res": false,
      };
    }
  }
}
