import 'package:flutter/material.dart';
import 'package:google_maps/Constants/app_colors.dart';
import 'package:google_maps/googel_maps/view_model/location_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
   final LatLng _center = const LatLng(31.5204, 74.3587);
  @override
  Widget build(BuildContext context) {
       final locationViewModel = Provider.of<LocationViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.secondaryBgColor,
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              locationViewModel.onMapCreated(controller);
            },
            initialCameraPosition:  CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            markers: locationViewModel.markers,
          ),
          
        ],
      ),
    );
  }
}