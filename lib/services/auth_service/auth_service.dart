import 'package:dartz/dartz.dart';

import '../../models/api_response/error.dart';
import '../../models/api_response/success.dart';

abstract class AuthService {
  Future<Either<ErrorResponse, Success>> login(String email, String password);
  Future<ApiRes> register(
    String fullName,
    String email,
    String password,
    String phone,
  );
  Future<Either<ErrorResponse, Success>> getEmailOTP(String email);
  Future<Either<ErrorResponse, Success>> verifyEmail(String email, String otp);

  //AuthService for rider/vehicle verification
  Future<Either<ErrorResponse, Success>> verifyVehicle(
    String driversIdImg,
    String vehicleType,
    String vehicleBrand,
    String vehicleLicensePlate,
  );

  Future<Either<ErrorResponse, Success>> addGuarantor(
    String guarantor1Name,
    String guarantor1Phone,
    String guarantor2Name,
    String guarantor2Phone,
  );

  Future<ApiRes> getUser();

  Future<ApiRes> updateProfile({
    required String name,
    required String email,
    required String phone,
  });

  //   Future<Either<ErrorResponse, ApiResponse>> verifyOTP({
  //   required String email,
  //   required String otp,
  // });

  Future<Either<ErrorResponse, ApiResponse>> forgotPassword({
    required String email,
  });

  Future<Either<ErrorResponse, ApiResponse>> resetPassword({
    required String password,
    required String otp,
  });
}
