import 'package:flutter/material.dart';

import '../models/torch_state.dart';
import '../viewmodels/torch_viewmodel.dart';

class TorchPage extends StatelessWidget {
  const TorchPage({super.key, required this.viewModel});

  final TorchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Torch Example')),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.status == TorchStatus.on ? 'Torch is ON' : 'Torch is OFF',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.turnOn,
                  child: const Text('Turn Torch On'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.turnOff,
                  child: const Text('Turn Torch Off'),
                ),
                if (viewModel.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
