import 'package:flutter/material.dart';
import 'package:tourch/tourch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torch Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Torch Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => TorchController.turnOn(),
                child: const Text('Turn Torch On'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => TorchController.turnOff(),
                child: const Text('Turn Torch Off'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
