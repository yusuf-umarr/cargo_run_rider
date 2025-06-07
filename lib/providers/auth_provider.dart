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

  String? _vehicleImg;
  String? get vehicleImg => _vehicleImg;
  String? _profileImg;
  String? get profileImg => _profileImg;

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
      _vehicleImg = file.path;

    
      notifyListeners();
    }
  }

  void pickProfileImg(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _profileImg = file.path;
      notifyListeners();

      if(_profileImg !=null){
        uploadProfilePic(context);
      }
    }
  }

  void clearImage() {
    _vehicleImg = null;
    _profileImg = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setAuthState(AuthState.authenticating);
    var response = await _authService.login(email, password);
    if (response.isError) {
      dev.log("response.data:${response.data}");
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
      // dev.log("response.data['data'][0]:${response.data['data'][0]}");
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
    context, {
    required String vehicleNumber,
    required String brand,
    required String vehicleType,
  }) async {
    setAuthState(AuthState.authenticating);
    if (vehicleImg != null) {
      var response = await _authService.verifyVehicle(
        vehicleImg!,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: redColor,
          content: Text("Please upload your driver's license first"),
        ),
      );
      setErrorMessage("Please upload your driver's license first");
      setAuthState(AuthState.unauthenticated);
    }
  }

  Future<void> uploadProfilePic(
    context,
  ) async {
    setAuthState(AuthState.authenticating);
    if (profileImg != null) {
      var response = await _authService.uploadProfilePic(
        profileImg!,
      );
      response.fold((error) {
        setErrorMessage(error.error);
        setAuthState(AuthState.unauthenticated);
      }, (success) {
        setAuthState(AuthState.authenticated);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: redColor,
          content: Text("Please select your profile photo"),
        ),
      );
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
