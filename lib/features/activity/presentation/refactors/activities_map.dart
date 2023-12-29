import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ExploreMap extends StatefulWidget {
  const ExploreMap({Key? key, required this.activities}) : super(key: key);

  final List<Activity> activities;

  @override
  _ExploreMapState createState() => _ExploreMapState();
}

class _ExploreMapState extends State<ExploreMap> {
  late GoogleMapController mapController;

  LatLng? _currentPosition;
  bool _isLoading = true;
  Activity? _selectedActivity;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _moveToCurrentLocation() {
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    }
  }

  Set<Marker> _buildActivityMarkers() {
    Set<Marker> markers = {};

    // Dodaj marker "My Location", jeśli dostępna jest aktualna lokalizacja
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: _currentPosition!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    markers.addAll(widget.activities.map((activity) {
      return Marker(
        markerId: MarkerId(activity.id),
        position: LatLng(activity.latitude, activity.longitude),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          setState(() {
            _selectedActivity = activity;
          });
          _showActivityModal();
        },
      );
    }));

    return markers;
  }

  void _showActivityModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: context.height * .35,
          child: Stack(
            children: [
              // Stack of images taking full available space
              Container(
                padding: const EdgeInsets.all(5).copyWith(bottom: 0),
                height: context.height * .2,
                width: context.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _selectedActivity!.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  width: context.width,
                  height: context.height * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedActivity!.title.length > 20
                            ? '${_selectedActivity!.title.substring(0, 20)}...'
                            : _selectedActivity!.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(_selectedActivity!.category.icon),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            _selectedActivity!.category.label,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Category: ${_selectedActivity!.category.label}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      // Add more details as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.transparent,
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition ?? const LatLng(0, 0),
                    zoom: 12.0,
                  ),
                  myLocationButtonEnabled: false,
                  markers:
                      _currentPosition != null ? _buildActivityMarkers() : {},
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToCurrentLocation,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
