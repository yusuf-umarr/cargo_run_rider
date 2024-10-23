import 'dart:developer';
import 'dart:io';

import 'package:cargorun_rider/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/auth_service/auth_service.dart';
import '../services/service_locator.dart';

enum AuthState {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final _authService = locator<AuthService>();

  AuthState _authState = AuthState.initial;
  AuthState get authState => _authState;

  RiderData? _user;
  RiderData? get user => _user;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String? _riderId;
  String? get riderId => _riderId;

  void setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void pickImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _riderId = file.path;
      notifyListeners();
    }
  }

  void clearImage() {
    _riderId = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.login(email, password);
    response.fold((error) {
      // if(error.error.s)

      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> addGuarantor(
    String guarantor1Name,
    String guarantor1Phone,
    String guarantor2Name,
    String guarantor2Phone,
  ) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.addGuarantor(
      guarantor1Name,
      guarantor1Phone,
      guarantor2Name,
      guarantor2Phone,
    );
    response.fold((error) {
      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> register(
    String fullName,
    String password,
    String phone,
  ) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.register(fullName, password, phone);
    response.fold((error) {
      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> getEmailOTP(String email) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.getEmailOTP(email);
    response.fold((error) {
      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> verifyEmailOTP(String email, String otp) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.verifyEmail(email, otp);
    response.fold((error) {
      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> sendOTP(String email) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.getEmailOTP(email);
    response.fold((error) {
      setErrorMessage(error.error);
      setAuthState(AuthState.unauthenticated);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> getUserProfile() async {
    var response = await _authService.getUser();

    if (response.isError) {
      setAuthState(AuthState.unauthenticated);
    } else {
      setAuthState(AuthState.authenticated);
      _user = RiderData.fromJson(response.data['data'][0]);

      notifyListeners();
    }
  }

  Future<void> updateProfile() async {
    var response = await _authService.getUser();

    if (response.isError) {
      setAuthState(AuthState.unauthenticated);
    } else {
      setAuthState(AuthState.authenticated);
      log("response.data['data'][0]:${response.data['data'][0]}");
      // _user = RiderData.fromJson(response.data['data'][0]);

      notifyListeners();
    }
  }

  Future<void> verifyVehicle(
    String vehicleNumber,
    String brand,
    String vehicleType,
  ) async {
    setAuthState(AuthState.authenticating);
    if (riderId != null) {
      var response = await _authService.verifyVehicle(
        riderId!,
        vehicleType,
        brand,
        vehicleNumber,
      );
      response.fold((error) {
        setErrorMessage(error.error);
        setAuthState(AuthState.unauthenticated);
      }, (success) {
        setAuthState(AuthState.authenticated);
      });
    } else {
      setErrorMessage("Please upload your driver's license first");
      setAuthState(AuthState.unauthenticated);
    }
  }
}
