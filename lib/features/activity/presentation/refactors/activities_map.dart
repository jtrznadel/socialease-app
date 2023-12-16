import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/explore/presentation/widgets/activity_marker_info_modal.dart';
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
  Activity? _selectedActivity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: (tapPosition, latLng) {
                    _handleMapTap(latLng);
                  },
                  initialZoom: 14,
                  initialCenter: const LatLng(50.041187, 21.999121),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedActivity != null)
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              _selectedActivity!
                                  .image!, // Replace with the appropriate field from your Activity model
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedActivity = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _selectedActivity!.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_selectedActivity!.category.label),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    double i = 0.0;
    for (var activity in widget.activities) {
      var latitude = 50.041187 + i;
      var longitude = 21.999121 + i;
      markers.add(
        CustomMarker(
          point: LatLng(latitude, longitude),
          onTap: () {
            setState(() {
              _selectedActivity = activity;
            });
          },
        ),
      );
      i += 0.01;
    }

    return markers;
  }

  void _handleMapTap(LatLng latLng) {
    setState(() {
      _selectedActivity = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      mapController.move(
        LatLng(locationData.latitude!, locationData.longitude!),
        50.0,
      );
    } catch (e) {
      print('Could not get location: $e');
    }
  }
}
