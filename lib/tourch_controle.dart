import 'package:flutter/services.dart';

class TorchController {
  static const platform = MethodChannel('samples.flutter.dev/torch');

  static Future<void> turnOn() async {
    try {
      await platform.invokeMethod('turnOn');
    } on PlatformException catch (e) {
      print("Failed to turn on torch: '${e.message}'.");
    }
  }

  static Future<void> turnOff() async {
    try {
      await platform.invokeMethod('turnOff');
    } on PlatformException catch (e) {
      print("Failed to turn off torch: '${e.message}'.");
    }
  }
}
