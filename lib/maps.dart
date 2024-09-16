import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapState();

}
class _MapState extends State<MapPage> {
  final LatLng initialLocation = LatLng(27.7172, 85.3240); // Example: Kathmandu
  final LatLng destinationLocation =
  LatLng(27.6780, 85.3140);
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(        title: const Text('M A P   &  N A V I G A T I O N'),
        centerTitle: true,
      ),
    body: FlutterMap(
      options: MapOptions(
        initialCenter: initialLocation,
        // Center the map over KTM
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // additionalOptions: {
          //   'accesstoken': 'https://api.mapbox.com/styles/v1/apalat/cm11poynh01fh01o33mdyhhtg/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXBhbGF0IiwiYSI6ImNtMTFwNmNqdjBidmIyaXMxdHRiZTV2MWsifQ.ZxtsWxX-ICYTvpYxwdQrqA'
          // },
          maxNativeZoom:
          19, // Scale tiles when the server doesn't support higher zoom levels
          // And many more recommended properties!
        ),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse(
                  'https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: initialLocation, // Initial location marker
              width: 40, // Set the width for the marker
              height: 40, // Set the height for the marker
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
            Marker(
              point: destinationLocation, // Destination location marker
              width: 40, // Set the width for the marker
              height: 40, // Set the height for the marker
              child: const Icon(
                Icons.flag,
                color: Colors.green,
                size: 40,
              ),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [initialLocation, destinationLocation], // List of points to connect
              strokeWidth: 4.0, // Width of the line
              color: Colors.blue, // Color of the line
            ),
          ],
        ),
      ],
    ),
  );
}
}