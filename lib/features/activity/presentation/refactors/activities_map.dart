import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/location_provider.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_map_tile.dart';

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
    _init();
  }

  Future<void> _init() async {
    await context.read<LocationProvider>().initLocation();
    setState(() {
      _currentPosition = context.read<LocationProvider>().currentPosition;
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
        return BlocProvider(
          create: (context) => sl<ActivityCubit>(),
          child: MapActivityTile(selectedActivity: _selectedActivity!),
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
              ? Center(
                  child: lt.LottieBuilder.asset(MediaRes.loading),
                )
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
      floatingActionButton: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: FloatingActionButton(
          onPressed: _moveToCurrentLocation,
          tooltip: 'My Location',
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
