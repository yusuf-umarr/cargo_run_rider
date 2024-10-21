import 'package:dartz/dartz.dart';

import '../../models/api_response/error.dart';
import '../../models/api_response/success.dart';

abstract class AuthService {
  Future<Either<ErrorResponse, Success>> login(String email, String password);
  Future<Either<ErrorResponse, Success>> register(
    String fullName,
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
}
