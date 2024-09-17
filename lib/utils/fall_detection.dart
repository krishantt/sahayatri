import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:telephony/telephony.dart';
import 'package:toastification/toastification.dart'; // SMS sending package
import 'package:shared_preferences/shared_preferences.dart';

class FallDetection {
  final Telephony telephony = Telephony.instance;
  bool hasFallen = false;
  bool smsPermissionGranted = false;
  bool cooldownActive = false;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  String phoneNumber = '';

  Future<void> _checkStoredPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedPhoneNumber = prefs.getString('phoneNumber');

    if (storedPhoneNumber != null) {
        phoneNumber = storedPhoneNumber;
    }
  }

  void startMonitoring() async {
    await checkPermissions();
    startFallDetection();
  }

  Future<void> checkPermissions() async {
    bool? permissionGranted = await telephony.requestPhoneAndSmsPermissions;
    smsPermissionGranted = permissionGranted ?? false; // Handle null case
  }

  void startFallDetection() {
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15 && !cooldownActive) {
        hasFallen = true;
        toastification.show(
          type: ToastificationType.error,
          title: const Text("Fall Detected!"),
          description: const Text(
            'Sending a message to your emergency contact.',
            style: TextStyle(color: Colors.black),
          ),
          showProgressBar: true,
        );
        sendSmsAlert();
        startCooldown();
      }
    });
  }

  void startCooldown() {
    cooldownActive = true;
    Future.delayed(const Duration(seconds: 5), () {
      cooldownActive = false; // Reset cooldown after 30 seconds
      hasFallen = false; // Reset fall status after cooldown
    });
  }

  void sendSmsAlert() async {
    await _checkStoredPhoneNumber();
    if (smsPermissionGranted) {
      telephony.sendSms(
        to: phoneNumber, // Replace with the actual emergency contact number
        message: "Fall detected! Please check on me immediately.",
      );
    } else {
      print('SMS permission not granted');
    }
  }
}
