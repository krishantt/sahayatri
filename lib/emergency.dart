import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/model_sheet.dart';

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
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
            Text('Stored Emergency Contact:'),
            SizedBox(height: 16),
            Text(
              phoneNumber,
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
              ),
            ),
            SizedBox(
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
              child: Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}
