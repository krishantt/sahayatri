import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sahayatri_app/utils/map_handler.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _center = const LatLng(1, 2);
  MapHandler maps = MapHandler();

  @override
  void initState() {
    super.initState();
    updateLocation();
  }

  Future<void> updateLocation() async {
    LatLng location = await maps.getLocation();
    setState(() {
      _center = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Location"),
      ),
      body: FlutterMap(
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 13.0, // Adjust zoom level
          ),
          children: [
            MarkerLayer(
              markers: [
                Marker(
                  point: _center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
