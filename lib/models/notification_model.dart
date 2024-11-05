class NotificationModel {
  final bool? success;
  final String? msg;
  final List<NotificationData>? data;

  NotificationModel({
    this.success,
    this.msg,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'],
      msg: json['msg'],
      data: (json['data'] as List?)
          ?.map((item) => NotificationData.fromJson(item))
          .toList(),
    );
  }
}

class NotificationData {
  final String? id;
  final String? userType;
  final String? userId;
  final String? title;
  final String? message;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  NotificationData({
    this.id,
    this.userType,
    this.userId,
    this.title,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'],
      userType: json['userType'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
