import 'dart:convert';

import 'package:find_iss/services/location_service.dart';
import 'package:find_iss/utils/common_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final getCurrentLatLng = FutureProvider<LatLng?>((ref) async=> await LocationService().getCurrentLocation());
final getISSCurrentLatLng = FutureProvider<LatLng?>((ref) async{
  LatLng? location =  await LocationService().getISSLocation();
  // if(location != null){
  //   ref.read(issCurrentRegionProvider.notifier).state = await LocationService().getCountryByLatLong(location.latitude, location.longitude);
  // }
  return location;
});
final timerProvider = StateProvider<int>((ref)=>0);
final issCurrentRegionProvider = StateProvider<String>((ref)=>"");
final issLocalTimeProvider = StateProvider<DateTime>((ref)=>DateTime.now());
final issUTCProvider = StateProvider<String>((ref)=>DateTime.now().timeZoneName);
