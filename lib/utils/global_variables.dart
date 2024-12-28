import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

CameraPosition defaultCameraPosition = const CameraPosition(
  target: LatLng(23.810331, 90.412521), // Bangladesh location
  zoom: 4.4746,
);
BitmapDescriptor? markerType;

DateFormat issLocalTimeFormatter = DateFormat("dd, MMM, yy hh:mm a");