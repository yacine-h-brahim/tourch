import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class ProximityWidget extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProximityWidgetState createState() => _ProximityWidgetState();
}

class _ProximityWidgetState extends State<ProximityWidget> {
  static const proxPlatform = MethodChannel("samples.flutter.dev/tourch");
  static const platform = MethodChannel('example_service');
  String serverState = 'Did not make the call yet';

  late StreamSubscription _proximitySubscription;
  bool isNear = false;
  Future<void> _startService() async {
    try {
      final result = await platform.invokeMethod('StartService');
      setState(() {
        serverState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopService() async {
    try {
      final result = await platform.invokeMethod('StopService');
      setState(() {
        serverState = result;
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
            await proxPlatform.invokeMethod('getisFlashlightState');
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
      backgroundColor:
          isNear ? const Color.fromRGBO(58, 58, 58, 1) : Colors.white,
      appBar: AppBar(
        backgroundColor:
            isNear ? const Color.fromRGBO(97, 97, 97, 1) : Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Start Service'),
              onPressed: _startService,
            ),
            ElevatedButton(
              child: const Text('Stop Service'),
              onPressed: _stopService,
            ),
            const SizedBox(height: 50),
            Container(
                height: 250,
                width: 250,
                child: isNear
                    ? const Text(
                        'on',
                        style: TextStyle(fontSize: 30),
                      )
                    : const Text('off', style: TextStyle(fontSize: 30))
                // Image.asset('assets/flashlight_on.png'
                //     : 'assets/flashlight_off.png'),
                ),
            Text(serverState),
          ],
        ),
      ),
    );
  }
}
