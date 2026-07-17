import 'package:flutter/foundation.dart';

import '../models/torch_state.dart';
import '../services/torch_service.dart';

/// Holds torch UI state and exposes the actions the View can trigger.
///
/// This is the M in MVVM's "V" — it depends only on [ITorchService]
/// (an abstraction), never on the concrete MethodChannel implementation.
/// That's what makes it trivially testable: inject a fake service in tests,
/// the real one in production. The View never touches [ITorchService]
/// directly, so swapping the service layer never requires touching the UI.
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

  /// Centralizes the busy/error handling so each action doesn't repeat it.
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
