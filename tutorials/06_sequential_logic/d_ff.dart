import 'package:rohd/rohd.dart';

class DFlipFlop extends Module {
  DFlipFlop(Logic data, Logic reset) {
    // declare input and output
    data = addInput('d', data);
    reset = addInput('reset', reset);

    final q = addOutput('q');

    Sequential(SimpleClockGenerator(10).clk, [
      If(reset, then: [q < 0], orElse: [q < data])
    ]);
  }

  Logic get q => output('q');
}

void main() async {
  final data = Logic();
  final reset = Logic();

  final dff = DFlipFlop(data, reset);
  await dff.build();

  print(dff.generateSynth());
}
