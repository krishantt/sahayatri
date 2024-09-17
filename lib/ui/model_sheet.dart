import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelUI extends StatelessWidget {
  ModelUI({super.key});
  String inputPhoneNumber = '';

  Future<void> _storePhoneNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', number);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set phone number for emergency contact',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  inputPhoneNumber = value;
                },
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (inputPhoneNumber.isNotEmpty) {
                    _storePhoneNumber(inputPhoneNumber);

                    Navigator.pop(context); // Close modal
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
