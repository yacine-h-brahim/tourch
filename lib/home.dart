import 'package:flutter/material.dart';

import 'tourch_controle.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: TorchController.turnOn,
            child: Text('Launch Torch'),
          ),
          ElevatedButton(
            onPressed: TorchController.turnOff,
            child: Text('Stop Torch'),
          )
        ],
      ),
    ));
  }
}
