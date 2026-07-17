import 'package:flutter/services.dart';

abstract class ITorchService {
  Future<void> turnOn();
  Future<void> turnOff();
}

class MethodChannelTorchService implements ITorchService {
  MethodChannelTorchService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('torch_channel');

  final MethodChannel _channel;

  @override
  Future<void> turnOn() => _channel.invokeMethod('turnOn');

  @override
  Future<void> turnOff() => _channel.invokeMethod('turnOff');
}
