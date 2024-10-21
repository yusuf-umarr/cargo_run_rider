import 'dart:developer';

class RiderOrderModel {
  bool? success;
  String? msg;
  List<OrderData>? data;

  RiderOrderModel({this.success, this.msg, this.data});

  RiderOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class OrderData {
  AddressDetails? addressDetails;
  ReceiverDetails? receiverDetails;
  String? id;
  String? orderId;
  String? trackingId;
  double? amount;
  dynamic userId;
  String? status;
  String? paymentStatus;
  String? deliveryService;
  String? deliveryOption;
  double? averageRating;
  double? deliveryFee;
  bool? isDelete;
  List<Rating>? ratings;
  String? createdAt;
  String? updatedAt;
  int? v;

  OrderData({
    this.addressDetails,
    this.receiverDetails,
    this.id,
    this.orderId,
    this.trackingId,
    this.amount,
    this.userId,
    this.status,
    this.paymentStatus,
    this.deliveryService,
    this.deliveryOption,
    this.averageRating,
    this.deliveryFee,
    this.isDelete,
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.v,
  });




  OrderData.fromJson(Map<String, dynamic> json) {
    addressDetails = json['addressDetails'] != null
        ? AddressDetails.fromJson(json['addressDetails'])
        : null;
    receiverDetails = json['receiverDetails'] != null
        ? ReceiverDetails.fromJson(json['receiverDetails'])
        : null;
    id = json['_id'];
    orderId = json['orderId'];
    trackingId = json['trackingId'];
    amount = json['amount'] != null ? json['amount'].toDouble() : 0.0;
    averageRating = json['averageRating'] != null ? json['averageRating'].toDouble() : 0.0;
    deliveryFee = json['deliveryFee'] != null ? json['deliveryFee'].toDouble() : 0.0;
    userId = json['userId'] ;
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    deliveryService = json['deliveryService'];
    deliveryOption = json['deliveryOption'];
    isDelete = json['isDelete'];
    if (json['ratings'] != null) {
      ratings = <Rating>[];
      json['ratings'].forEach((v) {
        ratings!.add(Rating.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
//
 
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addressDetails != null) {
      data['addressDetails'] = addressDetails!.toJson();
    }
    if (receiverDetails != null) {
      data['receiverDetails'] = receiverDetails!.toJson();
    }
    data['_id'] = id;
    data['orderId'] = orderId;
    data['trackingId'] = trackingId;
    data['amount'] = amount ?? 0.0;  // Safely handle null values
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['status'] = status;
    data['paymentStatus'] = paymentStatus;
    data['deliveryService'] = deliveryService;
    data['deliveryOption'] = deliveryOption;
    data['averageRating'] = averageRating ?? 0.0;
    data['deliveryFee'] = deliveryFee ?? 0.0;
    data['isDelete'] = isDelete;
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

// class OrderData {
//   AddressDetails? addressDetails;
//   ReceiverDetails? receiverDetails;
//   String? id;
//   String? orderId;
//   String? trackingId;
//   double? amount;
//   UserId? userId;
//   String? status;
//   String? paymentStatus;
//   String? deliveryService;
//   String? deliveryOption;
//   double? averageRating;
//   double? deliveryFee;
//   bool? isDelete;
//   List<Rating>? ratings;
//   String? createdAt;
//   String? updatedAt;
//   int? v;

//   OrderData({
//     this.addressDetails,
//     this.receiverDetails,
//     this.id,
//     this.orderId,
//     this.trackingId,
//     this.amount,
//     this.userId,
//     this.status,
//     this.paymentStatus,
//     this.deliveryService,
//     this.deliveryOption,
//     this.averageRating,
//     this.deliveryFee,
//     this.isDelete,
//     this.ratings,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   OrderData.fromJson(Map<String, dynamic> json) {
//     addressDetails = json['addressDetails'] != null
//         ? AddressDetails.fromJson(json['addressDetails'])
//         : null;
//     receiverDetails = json['receiverDetails'] != null
//         ? ReceiverDetails.fromJson(json['receiverDetails'])
//         : null;
//     id = json['_id'];
//     orderId = json['orderId'];
//     trackingId = json['trackingId'];
//     amount = json['amount'].toDouble();
//     userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
//     status = json['status'];
//     paymentStatus = json['paymentStatus'];
//     deliveryService = json['deliveryService'];
//     deliveryOption = json['deliveryOption'];
//     averageRating = json['averageRating'].toDouble();
//     deliveryFee = json['deliveryFee'].toDouble();
//     isDelete = json['isDelete'];
//     if (json['ratings'] != null) {
//       ratings = <Rating>[];
//       json['ratings'].forEach((v) {
//         ratings!.add(Rating.fromJson(v));
//       });
//     }
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     v = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (addressDetails != null) {
//       data['addressDetails'] = addressDetails!.toJson();
//     }
//     if (receiverDetails != null) {
//       data['receiverDetails'] = receiverDetails!.toJson();
//     }
//     data['_id'] = id;
//     data['orderId'] = orderId;
//     data['trackingId'] = trackingId;
//     data['amount'] = amount;
//     if (userId != null) {
//       data['userId'] = userId!.toJson();
//     }
//     data['status'] = status;
//     data['paymentStatus'] = paymentStatus;
//     data['deliveryService'] = deliveryService;
//     data['deliveryOption'] = deliveryOption;
//     data['averageRating'] = averageRating;
//     data['deliveryFee'] = deliveryFee;
//     data['isDelete'] = isDelete;
//     if (ratings != null) {
//       data['ratings'] = ratings!.map((v) => v.toJson()).toList();
//     }
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = v;
//     return data;
//   }
// }
// //
class AddressDetails {
  int? houseNumber;
  String? landMark;
  String? contactNumber;
  double? lng;
  double? lat;

  AddressDetails({this.houseNumber, this.landMark, this.contactNumber, this.lng, this.lat});

  AddressDetails.fromJson(Map<String, dynamic> json) {
    houseNumber = json['houseNumber'];
    landMark = json['landMark'];
    contactNumber = json['contactNumber'];
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['houseNumber'] = houseNumber;
    data['landMark'] = landMark;
    data['contactNumber'] = contactNumber;
    data['lng'] = lng;
    data['lat'] = lat;
    return data;
  }
}

class ReceiverDetails {
  String? name;
  String? phone;
  String? address;
  double? lng;
  double? lat;

  ReceiverDetails({this.name, this.phone, this.address, this.lng, this.lat});

  ReceiverDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['lng'] = lng;
    data['lat'] = lat;
    return data;
  }
}

class UserId {
  String? id;
  String? fullName;
  String? phone;
  double? wallet;
  bool? isDelete;
  bool? isVerified;
  String? verified;
  String? createdAt;
  String? updatedAt;
  String? email;
  String? verificationOtp;

  UserId({
    this.id,
    this.fullName,
    this.phone,
    this.wallet,
    this.isDelete,
    this.isVerified,
    this.verified,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.verificationOtp,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    phone = json['phone'];
    wallet = json['wallet'];
    isDelete = json['isDelete'];
    isVerified = json['isVerified'];
    verified = json['verified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    email = json['email'];
    verificationOtp = json['verificationOtp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['wallet'] = wallet;
    data['isDelete'] = isDelete;
    data['isVerified'] = isVerified;
    data['verified'] = verified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['email'] = email;
    data['verificationOtp'] = verificationOtp;
    return data;
  }
}

class Rating {
  int? rate;
  String? review;
  RatedBy? ratedBy;
  String? id;

  Rating({this.rate, this.review, this.ratedBy, this.id});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    review = json['review'];
    ratedBy = json['ratedBy'] != null ? RatedBy.fromJson(json['ratedBy']) : null;
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['review'] = review;
    if (ratedBy != null) {
      data['ratedBy'] = ratedBy!.toJson();
    }
    data['_id'] = id;
    return data;
  }
}

class RatedBy {
  String? id;
  String? fullName;
  String? phone;

  RatedBy({this.id, this.fullName, this.phone});

  RatedBy.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['fullName'] = fullName;
    data['phone'] = phone;
    return data;
  }
}
