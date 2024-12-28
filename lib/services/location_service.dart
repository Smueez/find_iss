import 'dart:convert';
import 'dart:developer';

import 'package:find_iss/apis/repositories/home_repository.dart';
import 'package:find_iss/models/common_response_model.dart';
import 'package:find_iss/services/shared_preference.dart';
import 'package:find_iss/utils/common_string.dart';
import 'package:find_iss/utils/enums.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  getLocationPermission()async{
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      await Geolocator.requestPermission();
    }
    enabled = await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      await Geolocator.requestPermission();
    }
    enabled = await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      Geolocator.openLocationSettings();
    }
  }
  LatLng? getLastStoredLocation(){
    String locStr = SharedPreferenceManager.readString(CommonString.location);
    if(locStr.isNotEmpty){
      Map locJson = jsonDecode(locStr);
      if(locJson.isNotEmpty){
        return LatLng(locJson[CommonString.lat], locJson[CommonString.lng]);
      }
    }
    return null;
  }

  Future<LatLng?> getCurrentLocation()async{
    await getLocationPermission();

    bool enabled = await Geolocator.isLocationServiceEnabled();
    if(enabled){
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  Future<String> getCountryByLatLong(double latitude, double longitude)async{
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      for(Placemark place in placemarks){
        if(place.country != null){
          if(place.country!.isNotEmpty){
            return place.country!;
          }
        }
      }
    }
    catch(e,s){
      log("$e, $s");
    }

    return "";
  }
  Future<bool> checkIfSameCounty(double latitude, double longitude)async{
    LatLng? currentLocation = await getCurrentLocation();
    String currentCountry = "";
    if(currentLocation != null){
      currentCountry = await getCountryByLatLong(currentLocation.longitude, currentLocation.longitude);
    }
    String issSLocation = await getCountryByLatLong(latitude, longitude);
    if(issSLocation.isEmpty || currentCountry.isEmpty){
      return false;
    }
    return issSLocation == currentCountry;

  }

  Future<LatLng?>getISSLocation()async{
    CommonResponse response = await HomeRepository().getIssCurrentLocation();
    if(response.responseType == EventType.success){
      return response.data;
    }
    else{
      LatLng? lastStoredLocation = getLastStoredLocation();
      if(lastStoredLocation != null){
        return lastStoredLocation;
      }

    }
    return null;
  }
}