import 'package:flutter_demo/ui/demos/7_testing/calculator_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //unit test
  test("the default answer is 0", () {
    final manager = CalculatorManager();
    final number = manager.answerNotifier.value;
    expect(number, 0);
  });

  test("number notifier starts at 1", () {
    final manager = CalculatorManager();
    manager.add("1", "2");

    final number = manager.answerNotifier.value;

    expect(number, 3);
  });
}
