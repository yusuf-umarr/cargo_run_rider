import 'package:cargorun_rider/models/location_model.dart';
import 'package:dartz/dartz.dart';
import '../../models/api_response/error.dart';
import '/models/api_response/success.dart';

abstract class OrderService {
  Future<Either<ErrorResponse, ApiResponse>> getOrders();
  Future<Either<ErrorResponse, ApiResponse>> getPendingOrders();

  Future<ApiRes> acceptRejectOrder(
    String orderId,
    String value,
  );
  Future<ApiRes> postRiderLocationWithOrderId(
    String orderId,
    Riderlocation riderlocation,
  
  );
}
