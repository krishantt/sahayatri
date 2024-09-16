import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class EPage extends StatefulWidget {
  const EPage({super.key});

  @override
  State<EPage> createState() => _EmergencyState();
}

class _EmergencyState extends State<EPage> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.sms.request();
    await Permission.location.request();
  }

  void sendSOS(String message, String receipent) async {
    // SmsMessage messageEvent = new SmsMessage(receipent, message);
    // messageEvent.onStateChanged.listen((state) {
    //   if (state == SmsMessageState.Sent) {
    //     print("SMS is sent!");
    //   } else if (state == SmsMessageState.Delivered) {
    //     print("SMS is delivered!");
    //   }
    // });
  }
  Future<void> shareLocation() async {
    await Firebase.initializeApp();
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('locations').child('user1');

    Position position = await Geolocator.getCurrentPosition();
    databaseReference.set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    String mapLink = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    String emergencyContact= '9869083012';
    String sosMessage = 'I need help. Please contact me immediately. My location: $mapLink';

    sendSOS(sosMessage, emergencyContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                shareLocation();
              },
              child: const Text('Send SOS and Share Location'),
            ),
          ],
        ),
      ),
    );
  }
}