import 'dart:convert';
import 'dart:developer';

import 'package:find_iss/apis/api_client.dart';
import 'package:find_iss/apis/apis.dart';
import 'package:find_iss/models/common_response_model.dart';
import 'package:find_iss/utils/enums.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/shared_preference.dart';
import '../../utils/common_string.dart';

class HomeRepository {
  ApiClient apiClient = ApiClient();
  Future<CommonResponse<LatLng>> getIssCurrentLocation()async{
    try{
      final response = await apiClient.getWithFullPath(
        Apis.issLocation,
      );
      if (response != null && response.statusCode == 200) {
        Map data = response.data;
        if(data.containsKey("message") && data.containsKey("iss_position")){
          if(data["message"] == "success"){
            if(data["iss_position"].isNotEmpty){

              double? lat = double.tryParse(data["iss_position"]["latitude"].toString());
              double? lng = double.tryParse(data["iss_position"]["longitude"].toString());
              if(lat == null || lng == null){
                return CommonResponse(responseType: EventType.error);
              }

              await SharedPreferenceManager.writeMap(CommonString.location, {
                CommonString.lat: lat,
                CommonString.lng: lng
              });
              LatLng latLng = LatLng(lat, lng);
              return CommonResponse(statusCode: response.statusCode!, responseType: EventType.success, data: latLng);
            }
          }
        }

      }
    }
    catch(e,s){
      log("$e $s");
    }
    return CommonResponse(responseType: EventType.error);
  }
}