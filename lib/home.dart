import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const proxPlatform = MethodChannel("samples.flutter.dev/tourch");
  static const platform = MethodChannel('example_service');
  String serviceState = 'Did not make the call yet';

  late StreamSubscription _proximitySubscription;
  bool isNear = false;
  Future<void> _startService() async {
    try {
      final result = await platform.invokeMethod('StartService');
      setState(() {
        serviceState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopService() async {
    try {
      final result = await platform.invokeMethod('StopService');
      setState(() {
        serviceState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    // Subscribe to the proximity stream when the widget initializes
    _proximitySubscription = proximityStream.listen((proximityData) {
      setState(() {
        // Update the state based on the received data
        isNear = proximityData;
      });
    });
  }

  @override
  void dispose() {
    _proximitySubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  Stream<bool> get proximityStream async* {
    try {
      while (true) {
        final bool result =
            await proxPlatform.invokeMethod('getFlashlightState');
        yield result; // Yield the received proximity data
      }
    } on PlatformException catch (e) {
      print("Failed to get proximity data: '${e.message}'.");
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _startService,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Start Service',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _stopService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stop, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Stop Service', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('The light is :', style: TextStyle(fontSize: 20)),
              Image.asset(
                isNear ? 'assets/lightOn.png' : 'assets/lightOff.png',
                height: 200,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              const Text('The State Of The service :',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              Text(serviceState,
                  style: const TextStyle(fontSize: 40, color: Colors.purple)),
            ],
          ),
        ),
      ),
    );
  }
}
