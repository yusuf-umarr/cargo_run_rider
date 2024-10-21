class ErrorResponse {
  ErrorResponse({
    required this.error,
  });

  final String error;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
      };
}
