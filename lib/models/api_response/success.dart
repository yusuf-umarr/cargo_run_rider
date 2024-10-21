class Success {
  final String message;

  Success({required this.message});

  factory Success.fromJson(Map<String, dynamic> json) {
    return Success(
      message: json['message'],
    );
  }
}

class ApiResponse {
  ApiResponse({
    required this.msg,
    required this.data,
  });

  final String? msg;
  final dynamic data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      msg: json["msg"],
      data: json["data"],
    );
  }
}
