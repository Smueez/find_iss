
import 'package:find_iss/screens/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/global_providers.dart';
import '../../../utils/global_variables.dart';

class HomePageUi extends ConsumerStatefulWidget {
  const HomePageUi({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends ConsumerState<HomePageUi> {

  late HomeController homeController;
  @override
  void initState(){
    homeController = HomeController(ref: ref, context: context);
    super.initState();
  }

  @override
  void dispose() {
    if(homeController.timer != null){
      homeController.timer?.cancel();
    }

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
            "ISS Tracker",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                homeController.refresh();
              },
              icon: const Icon(Icons.settings_input_antenna_outlined),
          ),
          IconButton(
            onPressed: (){
              homeController.logout();
            },
            icon: const Icon(Icons.logout, color: Colors.red,),
          )
        ],
      ),

      body: Stack(
        children: [
          Consumer(
              builder: (context,ref,_) {
                final asyncLocation = ref.watch(getISSCurrentLatLng);

                return asyncLocation.when(
                    data: (location){
                      if(location != null){
                        homeController.handleMap(location);
                      }

                      return googleMap(location);
                    },
                    error: (e,s){
                      return googleMap();
                    },
                    loading: ()=> const Center(child: CircularProgressIndicator(),)
                );

              }
          ),
          Consumer(
            builder: (context,ref,_) {
              final asyncLocation = ref.watch(getISSCurrentLatLng);
              return asyncLocation.when(
                  data: (location){
                    if(location == null){
                      return const SizedBox();
                    }
                    return Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer(
                                    builder: (context,ref,_) {
                                      String countryName = ref.watch(issCurrentRegionProvider);
                                      return Text(
                                        "Country: ${countryName.isEmpty?"N/A":countryName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                          fontWeight: FontWeight.bold
                                        ),
                                      );
                                    }
                                ),
                                SizedBox(height: 1.h,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Lat: ${location.latitude.toStringAsFixed(5)}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.w,),
                                    Expanded(
                                      child: Text(
                                        "Long: ${location.longitude.toStringAsFixed(5)}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 1.5.h,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Consumer(
                                        builder: (context,ref,_) {
                                          String utc = ref.watch(issUTCProvider);
                                          return Text(
                                            "UTC: $utc",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.sp
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                    SizedBox(width: 1.w,),
                                    Expanded(
                                      child: Consumer(
                                        builder: (context,ref,_) {
                                          DateTime localTime = ref.watch(issLocalTimeProvider);
                                          return Text(
                                            "Local Time: ${issLocalTimeFormatter.format(localTime)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.sp
                                            ),
                                          );
                                        }
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            )

                        )
                    );
                  },
                  error: (e,s)=> const SizedBox(),
                  loading: ()=>const SizedBox()
              );

            }
          ),
          Positioned(
              bottom: 5.h,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  child: Row(
                    children: [
                      Consumer(
                          builder: (context,ref,_) {
                            int seconds = ref.watch(timerProvider);
                            return Text(
                              seconds.toString(),
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20.sp
                              ),
                            );
                          }
                      ),
                      SizedBox(width: 1.w,),
                      Text(
                        "Seconds to track...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp
                        ),
                      ),
                    ],
                  ),
                ),
              )
          )

        ],
      )
    );
  }

  Widget googleMap([LatLng? issPosition]){
    Set<Marker> marker = {};
    if(issPosition != null){
      marker = {
        Marker(
            markerId: const MarkerId('ISS'),
            position: issPosition,
            icon: markerType??BitmapDescriptor.defaultMarker
        )
      };

    }

    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: defaultCameraPosition,
      markers: marker,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {

        homeController.mapController.complete(controller);
      },
    );
  }
}

