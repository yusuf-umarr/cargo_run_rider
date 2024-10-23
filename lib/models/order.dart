// class Order {
//   Order({
//     required this.addressDetails,
//     required this.receiverDetails,
//     required this.id,
//     required this.orderId,
//     required this.trackingId,
//     required this.userId,
//     required this.status,
//     required this.deliveryService,
//     required this.deliveryOption,
//     required this.averageRating,
//     required this.deliveryFee,
//     required this.isDelete,
//     required this.ratings,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.paymentStatus,
//   });

//   final AddressDetails? addressDetails;
//   final ReceiverDetails? receiverDetails;
//   final String? id;
//   final String? orderId;
//   final String? trackingId;
//   final dynamic userId;
//   final String? status;
//   final String? deliveryService;
//   final String? deliveryOption;
//   final num? averageRating;
//   final num? deliveryFee;
//   final bool? isDelete;
//   final List<dynamic> ratings;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final num? v;
//   final String? paymentStatus;

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       addressDetails: json["addressDetails"] == null
//           ? null
//           : AddressDetails.fromJson(json["addressDetails"]),
//       receiverDetails: json["receiverDetails"] == null
//           ? null
//           : ReceiverDetails.fromJson(json["receiverDetails"]),
//       id: json["_id"],
//       orderId: json["orderId"],
//       trackingId: json["trackingId"],
//       userId: json["userId"],
//       status: json["status"],
//       deliveryService: json["deliveryService"],
//       deliveryOption: json["deliveryOption"],
//       averageRating: json["averageRating"],
//       deliveryFee: json["deliveryFee"],
//       isDelete: json["isDelete"],
//       ratings: json["ratings"] == null
//           ? []
//           : List<dynamic>.from(json["ratings"]!.map((x) => x)),
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
//       v: json["__v"],
//       paymentStatus: json["paymentStatus"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "addressDetails": addressDetails?.toJson(),
//         "receiverDetails": receiverDetails?.toJson(),
//         "_id": id,
//         "orderId": orderId,
//         "trackingId": trackingId,
//         "userId": userId,
//         "status": status,
//         "deliveryService": deliveryService,
//         "deliveryOption": deliveryOption,
//         "averageRating": averageRating,
//         "deliveryFee": deliveryFee,
//         "isDelete": isDelete,
//         "ratings": ratings.map((x) => x).toList(),
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "paymentStatus": paymentStatus,
//       };
// }

// class AddressDetails {
//   AddressDetails({
//     required this.houseNumber,
//     required this.landMark,
//     required this.contactNumber,
//     required this.lng,
//     required this.lat,
//   });

//   final num? houseNumber;
//   final String? landMark;
//   final String? contactNumber;
//   final num? lng;
//   final num? lat;

//   factory AddressDetails.fromJson(Map<String, dynamic> json) {
//     return AddressDetails(
//       houseNumber: json["houseNumber"],
//       landMark: json["landMark"],
//       contactNumber: json["contactNumber"],
//       lng: json["lng"],
//       lat: json["lat"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "houseNumber": houseNumber,
//         "landMark": landMark,
//         "contactNumber": contactNumber,
//         "lng": lng,
//         "lat": lat,
//       };
// }

// class ReceiverDetails {
//   ReceiverDetails({
//     required this.name,
//     required this.phone,
//     required this.address,
//     required this.lng,
//     required this.lat,
//   });

//   final String? name;
//   final String? phone;
//   final String? address;
//   final num? lng;
//   final num? lat;

//   factory ReceiverDetails.fromJson(Map<String, dynamic> json) {
//     return ReceiverDetails(
//       name: json["name"],
//       phone: json["phone"],
//       address: json["address"],
//       lng: json["lng"],
//       lat: json["lat"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "phone": phone,
//         "address": address,
//         "lng": lng,
//         "lat": lat,
//       };
// }
