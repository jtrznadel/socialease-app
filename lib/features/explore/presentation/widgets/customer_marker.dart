import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends Marker {
  final VoidCallback? onTap;

  CustomMarker({
    required LatLng point,
    double radius = 10.0,
    this.onTap,
  }) : super(
          width: radius * 2,
          height: radius * 2,
          point: point,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green, // Change the color as needed
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
}
