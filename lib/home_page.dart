import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahayatri',
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff454b7e),
      
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/blindaid_logo.png'),
                // width: 150, height: 150),
            const SizedBox(height: 30),
            const Text(
              'Welcome to Sahayatri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your companion for vision assistance, navigation, and emergencies.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _speak("Vision Assistance");
                Navigator.pushNamed(context, '/camera_page');
              },
              style: ElevatedButton.styleFrom(
                iconColor: const Color(0xff454b7e),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Vision Assistance'),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final flutterTts = FlutterTts();

  NavigationDrawer({super.key});

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff454b7e),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sahayatri',
                  style: TextStyle(
                    color: Color(0xffb8bddd),
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              _speak("Home");
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            title: const Text('Vision Assistance'),
            onTap: () {
              _speak("Vision Assistance");
              Navigator.pushNamed(context, '/camera_page');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Emergency'),
            onTap: () {
              _speak("Emergency Settings");
              Navigator.pushNamed(context, '/emergency_page');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Maps'),
            onTap: () {
              _speak("Map Page");
              Navigator.pushNamed(context, '/map_page');
            },
          ),
        ],
      ),
    );
  }
}
