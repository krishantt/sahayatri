import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class MapHandler {
  final loc.Location location = loc.Location();

  void init() async {
    await _requestPermission();
    await getLocation();
  }

  Future<LatLng> getLocation() async {
    try {
      final loc.LocationData locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('locationHistory').add({
        'latitude': locationResult.latitude,
        'longitude': locationResult.longitude,
        'name': 'john',
        'timestamp': FieldValue.serverTimestamp(), // Adds a timestamp
      });
      return LatLng(locationResult.latitude!, locationResult.longitude!);
    } catch (e) {
      rethrow;
    }
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
