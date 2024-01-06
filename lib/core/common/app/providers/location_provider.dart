import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  Future<void> initLocation() async {
    await getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      print("Error getting current position: $e");
    }
  }

  Future<int> calculateDistance(
      double destLatitude, double destLongitude) async {
    await getCurrentPosition();
    const double earthRadius = 6371; // in kilometers

    double lat1 = _currentPosition!.latitude;
    double lon1 = _currentPosition!.longitude;
    double lat2 = destLatitude;
    double lon2 = destLongitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c * 1000; // convert to meters

    return distance.round().toInt();
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
