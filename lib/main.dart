import 'package:flutter/material.dart';

import 'services/torch_service.dart';
import 'viewmodels/torch_viewmodel.dart';
import 'views/torch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Composition root: the one place that knows about the concrete
  // service implementation. Everything downstream only sees abstractions
  // (ITorchService) or the ViewModel — this is the only wiring point,
  // which is what makes each layer swappable and unit-testable on its own.
  final TorchViewModel _torchViewModel = TorchViewModel(
    torchService: MethodChannelTorchService(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torch Example',
      home: TorchPage(viewModel: _torchViewModel),
    );
  }
}
