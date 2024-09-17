import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/model_sheet.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  EmergencyPageState createState() => EmergencyPageState();
}

class EmergencyPageState extends State<EmergencyPage> {
  String phoneNumber = '';

  Future<void> _checkStoredPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedPhoneNumber = prefs.getString('phoneNumber');

    if (storedPhoneNumber != null) {
      setState(() {
        phoneNumber = storedPhoneNumber;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStoredPhoneNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Stored Emergency Contact:'),
            const SizedBox(height: 16),
            Text(
              phoneNumber,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 50,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (context) {
                    return ModelUI();
                  },
                );
                _checkStoredPhoneNumber();
              },
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}
