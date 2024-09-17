import 'package:flutter/material.dart';
import 'package:sahayatri_app/utils/fall_detection.dart';
import 'home_page.dart';
import 'vision.dart';
import 'emergency.dart';
import 'maps.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:toastification/toastification.dart';

void main() {
  Gemini.init(apiKey: "Insert API Key here.");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FallDetection fall = FallDetection();
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    // Start fall detection monitoring when the app starts
    fall.startMonitoring();
  }



  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff454b7e),
          scaffoldBackgroundColor: const Color(0xffb8bddd),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            // Use 'bodyLarge' instead of 'bodyText1'
            bodyMedium: TextStyle(
                color:
                    Colors.black54), // Use 'bodyMedium' instead of 'bodyText2'
          ),
        ),
        home: HomePage(),
        routes: {
          '/home': (context) => HomePage(),
          '/camera_page': (context) => const CameraScreen(),
          '/emergency_page': (context) =>
              EmergencyPage(), // Updated route for emergency page
          '/map_page': (context) => const MapPage(),
        },
      ),
    );
  }
}
