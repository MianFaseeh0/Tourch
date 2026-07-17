import 'package:flutter/services.dart';

/// Abstraction over "however we talk to the torch hardware."
///
/// The ViewModel depends on this interface, not on [MethodChannelTorchService]
/// directly (Dependency Inversion). That also satisfies Interface
/// Segregation — callers only ever need these two methods — and Open/Closed:
/// a fake, a mock, or a different native implementation can be swapped in
/// without touching the ViewModel or View.
abstract class ITorchService {
  Future<void> turnOn();
  Future<void> turnOff();
}

/// Concrete implementation that talks to native code via a MethodChannel.
///
/// Single Responsibility: this class's only job is platform communication.
/// It knows nothing about UI state, loading flags, or error presentation —
/// that belongs to the ViewModel.
class MethodChannelTorchService implements ITorchService {
  MethodChannelTorchService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('torch_channel');

  final MethodChannel _channel;

  @override
  Future<void> turnOn() => _channel.invokeMethod('turnOn');

  @override
  Future<void> turnOff() => _channel.invokeMethod('turnOff');
}
