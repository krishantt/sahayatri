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
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(title: const Text('M A P   &  N A V I G A T I O N'),
        centerTitle: true,) ,

      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(27.7172, 85.3240),
          // Center the map over KTM
          initialZoom: 9.2,
        ),
        children: [
          TileLayer( // Display map tiles from any source
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            // OSMF's Tile Server
            userAgentPackageName: 'com.example.app',
            // additionalOptions: {
            //   'accesstoken': 'https://api.mapbox.com/styles/v1/apalat/cm11poynh01fh01o33mdyhhtg/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXBhbGF0IiwiYSI6ImNtMTFwNmNqdjBidmIyaXMxdHRiZTV2MWsifQ.ZxtsWxX-ICYTvpYxwdQrqA'
            // },
            maxNativeZoom: 19, // Scale tiles when the server doesn't support higher zoom levels
            // And many more recommended properties!
          ),
          RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse(
                        'https://openstreetmap.org/copyright')), // (external)
              ),
              // Also add images...
            ],
          ),
        ],
      ));
}
}

