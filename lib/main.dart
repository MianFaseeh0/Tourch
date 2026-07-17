import 'package:flutter/material.dart';

import 'services/torch_service.dart';
import 'viewmodels/torch_viewmodel.dart';
import 'views/torch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
