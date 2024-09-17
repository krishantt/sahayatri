import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class MapHandler {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  void init() async{
    await _requestPermission();
    await getLocation();
  }

  Future<LatLng> getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('locationHistory').add({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'john',
        'timestamp': FieldValue.serverTimestamp(),  // Adds a timestamp
      });
      return LatLng(_locationResult.latitude!, _locationResult.longitude!);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      _locationSubscription = null;
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'john'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
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
