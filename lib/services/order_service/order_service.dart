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
}
