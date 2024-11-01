import 'dart:math';

class LocationService {
  // Earth's radius in kilometers
  static const double earthRadiusKm = 6371.0;

  // Method to calculate the distance in kilometers
  static double calculateDistance({
    required double riderLat,
    required double riderLng,
    required double packageLat,
    required double packageLng,
  }) {
    // Convert latitude and longitude from degrees to radians
    final double riderLatRad = _toRadians(riderLat);
    final double riderLngRad = _toRadians(riderLng);
    final double packageLatRad = _toRadians(packageLat);
    final double packageLngRad = _toRadians(packageLng);

    // Haversine formula
    final double dLat = packageLatRad - riderLatRad;
    final double dLng = packageLngRad - riderLngRad;

    final double a = pow(sin(dLat / 2), 2) +
        cos(riderLatRad) * cos(packageLatRad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    return earthRadiusKm * c;
  }

  // Helper method to convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
