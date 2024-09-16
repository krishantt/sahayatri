import 'package:flutter/material.dart';
import 'home_page.dart';
import 'vision.dart';
import 'emergency.dart';
import 'Maps.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: "Insert key here.");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff454b7e),
        scaffoldBackgroundColor: const Color(0xffb8bddd),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black87), // Use 'bodyLarge' instead of 'bodyText1'
          bodyMedium: TextStyle(
              color: Colors.black54), // Use 'bodyMedium' instead of 'bodyText2'
        ),
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/camera_page': (context) => const CameraScreen(),
        '/emergency_page': (context) => const EPage(),
        '/map_page': (context) => const MapPage(),
      },
    );
  }
}

