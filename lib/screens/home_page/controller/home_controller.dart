import 'dart:async';

import 'package:find_iss/apis/repositories/home_repository.dart';
import 'package:find_iss/main.dart';
import 'package:find_iss/models/common_response_model.dart';
import 'package:find_iss/routes/router_name.dart';
import 'package:find_iss/utils/common_dialogs.dart';
import 'package:find_iss/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worldtime/worldtime.dart';

import '../../../providers/global_providers.dart';
import '../../../services/location_service.dart';
import '../../../utils/global_variables.dart';

class HomeController {
  LocationService locationService = LocationService();
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  HomeRepository repository = HomeRepository();
  WidgetRef ref;
BuildContext context;
  HomeController({required this.ref, required this.context}){
    WidgetsBinding.instance.addPostFrameCallback((v)async{
      await initialCameraPosition();
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(defaultCameraPosition));
      resetLocationTracking();
    });
  }
  initialCameraPosition()async{
    CommonResponse response = await repository.getIssCurrentLocation();
    if(response.responseType == EventType.success){
      defaultCameraPosition = CameraPosition(
        target: response.data, // Bangladesh location
        zoom: 4.4746,
      );
    }

  }
  Timer? timer;
  resetLocationTracking(){
    timer = Timer.periodic(
        const Duration(seconds: 1),
            (t){
              setTimer(t.tick);
              // ref.refresh(getISSCurrentLatLng);
            }
    );
  }

  setTimer(int tick){
    int seconds = tick % 60;
    if(tick != 0 && seconds == 0){
      seconds = 60;
    }
    ref.read(timerProvider.notifier).state = seconds;
    if(seconds == 0 || seconds == 60){
      ref.refresh(getISSCurrentLatLng);
    }
  }

  checkIfISSUpAbove(LatLng issPosition, String issCountry)async{
    LatLng? currentLocation = await locationService.getCurrentLocation();
    if(currentLocation != null){
      String myCountry = await locationService.getCountryByLatLong(currentLocation.latitude, currentLocation.longitude);
      if(myCountry.isNotEmpty && issCountry.isNotEmpty){
        if(myCountry.toLowerCase() == issCountry.toLowerCase()){
          CommonDialogs().showISSUpAboveDialog(context);
        }
      }
    }
  }

  handleDateTime(LatLng issPosition)async{
    final worldTimePlugin = Worldtime();
    DateTime issLocalTime = await worldTimePlugin.timeByLocation(latitude: issPosition.latitude, longitude: issPosition.longitude);
    ref.read(issLocalTimeProvider.notifier).state = issLocalTime;
    ref.read(issUTCProvider.notifier).state = issLocalTime.timeZoneName;
  }

  Future<CameraPosition>handleMap(LatLng issPosition)async{
    CameraPosition cameraPosition = CameraPosition(
      target: issPosition,
      zoom: 4.4746,
    );

    String issCountry = await locationService.getCountryByLatLong(issPosition.latitude, issPosition.longitude);
    checkIfISSUpAbove(issPosition, issCountry);
    handleDateTime(issPosition);
    ref.read(issCurrentRegionProvider.notifier).state = issCountry;
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


    return cameraPosition;
  }

  logout()async{
    await FirebaseAuth.instance.currentUser?.delete();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(RouterName.splashScreen, (v)=>false);
  }


  refresh(){
    ref.refresh(getISSCurrentLatLng);
  }

}