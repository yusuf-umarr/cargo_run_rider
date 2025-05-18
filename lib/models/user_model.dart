class UserRiderModel {
  final bool? success;
  final String? msg;
  final List<RiderData>? data;

  UserRiderModel({
    this.success,
    this.msg,
    this.data,
  });

  factory UserRiderModel.fromJson(Map<String, dynamic> json) {
    return UserRiderModel(
      success: json['success'],
      msg: json['msg'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => RiderData.fromJson(e)).toList()
          : null,
    );
  }
}

class RiderData {
  final Vehicle? vehicle;
  final Guarantors? guarantors;
  final String? id;
  final String? fullName;
  final String? phone;
  final bool? isDelete;
  final bool? isVerified;
  final String? verifiedCredentials;
  final String? verified;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? email;
  final String? verificationOtp;
  final String? profileImage;

  RiderData({
    this.vehicle,
    this.guarantors,
    this.id,
    this.fullName,
    this.phone,
    this.isDelete,
    this.isVerified,
    this.verifiedCredentials,
    this.verified,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.email,
    this.verificationOtp,
    this.profileImage,
  });

  factory RiderData.fromJson(Map<String, dynamic> json) {
    return RiderData(
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      guarantors: json['guarantors'] != null
          ? Guarantors.fromJson(json['guarantors'])
          : null,
      id: json['_id'] ?? "",
      fullName: json['fullName'] ?? "",
      phone: json['phone'] ?? "",
      isDelete: json['isDelete'] ?? false,
      isVerified: json['isVerified'] ?? false,
      verifiedCredentials: json['verifiedCredentials'],
      verified: json['verified'],
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      v: json['__v'] ?? 0,
      email: json['email'] ?? "",
      verificationOtp: json['verificationOtp'] ?? "",
      profileImage: json['profileImage'] ?? "",
    );
  }
}

class Vehicle {
  final String? brand;
  final String? image;
  final String? plateNumber;
  final String? vehicleType;

  Vehicle({
    this.brand,
    this.image,
    this.plateNumber,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json['brand'],
      image: json['image'],
      plateNumber: json['plateNumber'],
      vehicleType: json['vehicleType'],
    );
  }
}

class Guarantors {
  final String? nameOne;
  final String? phoneOne;
  final String? nameTwo;
  final String? phoneTwo;

  Guarantors({
    this.nameOne,
    this.phoneOne,
    this.nameTwo,
    this.phoneTwo,
  });

  factory Guarantors.fromJson(Map<String, dynamic> json) {
    return Guarantors(
      nameOne: json['nameOne'],
      phoneOne: json['phoneOne'],
      nameTwo: json['nameTwo'],
      phoneTwo: json['phoneTwo'],
    );
  }
}
