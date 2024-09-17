import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage> {
  final LatLng initialLocation = LatLng(27.7172, 85.3240); // Kathmandu
  final LatLng destinationLocation = LatLng(27.6780, 85.3140); // Example destination

  List<LatLng> routePoints = []; // Stores points for the polyline

  final String mapboxApiKey = 'pk.eyJ1IjoiYXBhbGF0IiwiYSI6ImNtMTFwNmNqdjBidmIyaXMxdHRiZTV2MWsifQ.ZxtsWxX-ICYTvpYxwdQrqA'; // Your Mapbox API key

  @override
  void initState() {
    super.initState();
    _fetchRoute(); // Fetch route on initialization
  }

  Future<void> _fetchRoute() async {
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/walking/${initialLocation.longitude},${initialLocation.latitude};${destinationLocation.longitude},${destinationLocation.latitude}?geometries=geojson&access_token=$mapboxApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract route geometry (the list of coordinates)
        final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

        // Convert the coordinates into LatLng and store in routePoints
        setState(() {
          routePoints = coordinates
              .map((coord) => LatLng(coord[1], coord[0])) // Convert to LatLng
              .toList();
        });
      } else {
        print('Failed to load route');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M A P   &  N A V I G A T I O N'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialLocation,
          initialZoom: 13.0, // Adjust zoom level
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxApiKey',
            userAgentPackageName: 'com.example.app',
            maxNativeZoom: 19,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'Mapbox',
                onTap: () => launchUrl(
                    Uri.parse('https://www.mapbox.com/about/maps/')),
              ),
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(
                    Uri.parse('https://www.openstreetmap.org/copyright')),
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: initialLocation,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: destinationLocation,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.flag,
                  color: Colors.green,
                  size: 40,
                ),
              ),
            ],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints, // Use the fetched route points
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}