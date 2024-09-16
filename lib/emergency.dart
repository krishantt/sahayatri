import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'dart:math'; // Import the math library for sqrt()

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final Telephony telephony = Telephony.instance;
  bool hasFallen = false;
  bool smsPermissionGranted = false;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    startFallDetection();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<void> checkPermissions() async {
    bool? permissionGranted = await telephony.requestPhoneAndSmsPermissions;
    setState(() {
      smsPermissionGranted = permissionGranted ?? false; // Handle null case
    });
  }

  void startFallDetection() {
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15) {
        setState(() {
          hasFallen = true;
        });
        sendSmsAlert();
      }
    });
  }

  void sendSmsAlert() {
    if (smsPermissionGranted) {
      telephony.sendSms(
        to: "9869083012", // Replace with the actual emergency contact number
        message: "Fall detected! Please check on me immediately.",
      );
    } else {
      print('SMS permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
      ),
      body: Center(
        child: hasFallen
            ? const Text('Fall detected! Sending alert...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            : const Text('Monitoring for fall...', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
