import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await context.read<LocationProvider>().initLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position) {
    setState(() {
      markers.clear(); // Clear existing markers
      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (_, provider, __) {
      if (provider.currentPosition != null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Location'),
          ),
          backgroundColor: Colors.white,
          body: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
              ),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: provider.currentPosition!,
                  zoom: 16.0,
                ),
                myLocationButtonEnabled: false,
                onTap: (LatLng position) {
                  _addMarker(position);
                },
                markers: markers,
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: FloatingActionButton(
                  onPressed: () {
                    provider.getCurrentPosition();
                    mapController.animateCamera(
                      CameraUpdate.newLatLng(provider.currentPosition!),
                    );
                  },
                  tooltip: 'My Location',
                  child: const Icon(Icons.my_location),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  if (markers.isNotEmpty) {
                    Navigator.pop(context, markers.first.position);
                  }
                },
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.check,
                ),
              ),
            ],
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
