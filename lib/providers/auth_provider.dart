import 'dart:developer' as dev;
import 'dart:io';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:http/http.dart' as http;

import 'package:cargorun_rider/models/user_model.dart';
import 'package:cargorun_rider/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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

  File imageUpload = File("");
  dynamic imageFile;

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
    if (response.isError) {
      setErrorMessage(response.data['msg']);

      // dev.log("response.data:${response.data['msg']}");
      setAuthState(AuthState.unauthenticated);
    } else {
      setAuthState(AuthState.authenticated);
    }
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
    String email,
    String password,
    String phone,
  ) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.register(
      fullName,
      email,
      password,
      phone,
    );
    dev.log("response:${response.data['msg']}");
    if (response.isError) {
      setErrorMessage(response.data['msg']);
      setAuthState(AuthState.unauthenticated);
    } else {
      setAuthState(AuthState.authenticated);
    }
    dev.log("response:${response}");
    // response.fold((error) {
    //   setErrorMessage(error.error);
    //   setAuthState(AuthState.unauthenticated);
    // }, (success) {
    //   setAuthState(AuthState.authenticated);
    // });
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

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.updateProfile(
      name: name,
      phone: phone,
      email: email,
    );

    if (response.isError) {
      setAuthState(AuthState.unauthenticated);
    } else {
      setAuthState(AuthState.authenticated);
      toast("Profile updated successful");

      getUserProfile();

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

  Future<void> forgotPassword({required String email}) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.forgotPassword(email: email);
    response.fold((error) {
      setAuthState(AuthState.unauthenticated);
      setErrorMessage(error.error);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> resetPassword({
    required String password,
    required String otp,
  }) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.resetPassword(
      password: password,
      otp: otp,
    );
    response.fold((error) {
      setAuthState(AuthState.unauthenticated);
      setErrorMessage(error.error);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  //   Future<void> verifyOTP({required String otp, required String email}) async {
  //   setAuthState(AuthState.authenticating);
  //   var response = await _authService.verifyOTP(otp: otp, email: email);
  //   response.fold((error) {
  //     setAuthState(AuthState.unauthenticated);
  //     setErrorMessage(error.error);
  //   }, (success) {
  //     setAuthState(AuthState.authenticated);
  //   });
  // }

  Future<void> getOTP({required String email}) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.getEmailOTP(email);
    response.fold((error) {
      setAuthState(AuthState.unauthenticated);
      setErrorMessage(error.error);
    }, (success) {
      setAuthState(AuthState.authenticated);
    });
  }

  Future<void> selectImages() async {
    imageUpload = await myUploadImage();
    imageFile = imageUpload;

    if (imageFile != null) {
      Map image = {"image": imageUpload.path};

      await uploadImage(file: image);
    }

    notifyListeners();
  }

  Future<dynamic> uploadImage({
    BuildContext? context,
    file,
    int responseCode = 200,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("UrlEndpoints.uploadImage"));

      request.headers.addAll(headers);
      request.files.add(
          await http.MultipartFile.fromPath("profileImage", imageUpload.path));

      return request.send().then((response) {
        return http.Response.fromStream(response).then((onValue) {
          debugPrint("response1:${onValue.body}");
          // authProvider.getProfile();
        });
      });
    } catch (e) {
      debugPrint("response:$e");
      return null;
    }
  }
}
