import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/demos/7_testing/calculator_manager.dart';

class CalculatorDemo extends StatefulWidget {
  const CalculatorDemo({super.key});

  @override
  State<CalculatorDemo> createState() => _TestingDemoState();
}

class _TestingDemoState extends State<CalculatorDemo> {
  final manager = CalculatorManager();
  final firstController = TextEditingController();
  final secondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 50, child: TextField(controller: firstController)),
            SizedBox(width: 10),
            Text("+"),
            SizedBox(width: 10),
            SizedBox(width: 50, child: TextField(controller: secondController)),
            SizedBox(width: 10),
            Text("="),
            SizedBox(width: 10),
            ValueListenableBuilder(
              valueListenable: manager.answerNotifier,
              builder: (context, value, child) {
                return Text("$value");
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                final first = firstController.text;
                final second = secondController.text;
                final result = manager.add(first, second);
              },
              child: Text("Calculate"),
            ),
          ],
        ),
      ),
    );
  }
}
