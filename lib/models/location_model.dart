
class Riderlocation {
  Riderlocation({

    required this.lng,
    required this.lat,
  });


  final num? lng;
  final num? lat;

  factory Riderlocation.fromJson(Map<String, dynamic> json) {
    return Riderlocation(
  
      lng: json["lng"],
      lat: json["lat"],
    );
  }

  Map<String, dynamic> toJson() => {

        "lng": lng,
        "lat": lat,
      };
}