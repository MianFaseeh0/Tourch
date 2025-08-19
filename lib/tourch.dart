import 'package:flutter/services.dart';

class TorchController {
  static const _channel = MethodChannel('torch_channel');

  static Future<void> turnOn() async {
    await _channel.invokeMethod('turnOn');
  }
  static Future<void> turnOff() async {
    await _channel.invokeMethod('turnOff');
  }
}
