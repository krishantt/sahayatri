import 'package:flutter/material.dart';
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
          centerTitle: true,)
    );
  }
}