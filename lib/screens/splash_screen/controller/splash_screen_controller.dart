import 'package:find_iss/apis/repositories/home_repository.dart';
import 'package:find_iss/main.dart';
import 'package:find_iss/routes/router_name.dart';
import 'package:find_iss/services/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/asset_name.dart';
import '../../../utils/global_variables.dart';

class SplashScreenController {
  gotoNextPage(bool canTransit)async{
    if(canTransit){
      WidgetsBinding.instance.addPostFrameCallback((v)async{
        await Future.delayed(const Duration(seconds: 2));
        User? currentUser = FirebaseAuth.instance.currentUser;
        await initialCameraPosition();
        // String token = SharedPreferenceManager.readString(CommonString.tokens);
        await LocationService().getLocationPermission();
        if(!await Permission.location.isGranted){
          return;
        }
        if(currentUser == null){
          navigatorKey.currentState?.pushNamedAndRemoveUntil(RouterName.signInScreen, (v)=>false);
        }
        else{
          navigatorKey.currentState?.pushNamedAndRemoveUntil(RouterName.homeScreen, (v)=>false);
        }
      });
    }
  }

  initialCameraPosition()async{
    markerType =  await BitmapDescriptor.asset( ImageConfiguration(size: Size(28.sp, 28.sp)),
            AssetPath.satelliteMarker);
    LatLng? position = await LocationService().getISSLocation();
    if(position != null){
      defaultCameraPosition = CameraPosition(
        target: position, // Bangladesh location
        zoom: 4.4746,
      );
    }

  }
}