import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationViewModel extends ChangeNotifier {
  late GoogleMapController mapController;
  Set<Marker> markers = {};



  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await changeMapStyle();
    await moveToCurrentLocation();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> moveToCurrentLocation() async {
    Position position = await getCurrentLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> changeMapStyle() async {
    try {
      String style = await rootBundle.loadString('assets/map_style.json');
      if (style.isNotEmpty) {
        // ignore: deprecated_member_use
        mapController.setMapStyle(style);
        debugPrint("Map style applied successfully! 🎉");
      } else {
        debugPrint("Error: Map style JSON is empty.");
      }
    } catch (e) {
      debugPrint("Error loading map style: $e");
    }
  }
}

class UserLocation {
  final LatLng position;
  final String imageUrl;

  UserLocation({required this.position, required this.imageUrl});
}
