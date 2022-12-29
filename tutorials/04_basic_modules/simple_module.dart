import 'package:rohd/rohd.dart';
import 'package:test/test.dart';

class SimpleModule extends Module {
  // Variables are now marked as global variables
  late Logic output1;
  late final Logic input1;

  SimpleModule(Logic in1) {
    // register input port
    input1 = addInput('input_1', in1);

    // register output port
    output1 = addOutput('out');

    // Module Logic
    output1 <= input1;
  }

  // @override
  // Future<void> build() async {
  //   // Move Logic to here instead
  //   output1 <= input1;

  //   await super.build();
  // }
}

void main() async {
  final input = Const(1);
  final simModule = SimpleModule(input);
  await simModule.build();

  test('should return input value.',
      () => expect(simModule.signals.first.value.toInt(), equals(1)));

  test(
      'should generate system verilog code.',
      () =>
          expect(simModule.generateSynth(), contains('module SimpleModule(')));
}
