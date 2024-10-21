import 'package:dartz/dartz.dart';
import '../../models/api_response/error.dart';
import '/models/api_response/success.dart';

abstract class OrderService {
  Future<Either<ErrorResponse, ApiResponse>> getOrders();

  Future<Either<ErrorResponse, Success>> acceptRejectOrder(
    String orderId,
    String value,
  );
}
