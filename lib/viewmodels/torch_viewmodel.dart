import 'package:flutter/foundation.dart';

import '../models/torch_state.dart';
import '../services/torch_service.dart';

class TorchViewModel extends ChangeNotifier {
  TorchViewModel({required ITorchService torchService})
      : _torchService = torchService;

  final ITorchService _torchService;

  TorchStatus _status = TorchStatus.off;
  TorchStatus get status => _status;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> turnOn() => _guard(() async {
        await _torchService.turnOn();
        _status = TorchStatus.on;
      });

  Future<void> turnOff() => _guard(() async {
        await _torchService.turnOff();
        _status = TorchStatus.off;
      });

  Future<void> _guard(Future<void> Function() action) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
    } catch (e) {
      _errorMessage = 'Could not reach the torch: $e';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }
}
