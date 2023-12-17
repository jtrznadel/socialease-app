import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/explore/presentation/widgets/customer_marker.dart';

class ExploreMap extends StatefulWidget {
  const ExploreMap({Key? key, required this.activities}) : super(key: key);

  final List<Activity> activities;

  @override
  _ExploreMapState createState() => _ExploreMapState();
}

class _ExploreMapState extends State<ExploreMap> {
  final MapController mapController = MapController();
  final Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(50.041187, 21.999121),
              initialZoom: 10,
            ),
            children: [
              TileLayer(
                  urlTemplate:
                      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    // Add markers for activities
    List<Marker> markers = [];
    double i = 0.0;
    for (var activity in widget.activities) {
      var latitude = 50.041187;
      var longitude = 21.999121;

      markers.add(
        CustomMarker(
            width: 100,
            height: 120,
            point: LatLng(latitude + i, longitude + i),
            activity: activity),
      );
      i += 0.1;
    }

    return markers;
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await location.getLocation();
      mapController.move(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
        15.0,
      );
    } catch (e) {
      print('Could not get location: $e');
    }
  }
}
