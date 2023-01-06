import 'package:rohd/rohd.dart';

class DFlipFlop extends Module {
  DFlipFlop(Logic data, Logic reset, Logic clk) {
    // declare input and output
    data = addInput('d', data);
    reset = addInput('reset', reset);
    clk = addInput('clk', clk);

    final q = addOutput('q');

    Sequential(clk, [
      If(reset, then: [q < 0], orElse: [q < data])
    ]);
  }

  Logic get q => output('q');
}

class ShiftRegister extends Module {
  ShiftRegister(Logic clk, Logic reset, Logic din) {
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);
    din = addInput('din', din);

    final nBit = din.width;

    final dout = addOutput('shift_reg', width: nBit);
    dout < 0;

    Sequential(clk, [
      IfBlock([
        Iff(reset, [
          dout < 0,
        ]),
        Else([
          dout < [dout.getRange(0, nBit - 1), din[nBit - 1]].swizzle(),
        ])
      ])
    ]);
  }

  Logic get outputRes => output('shift_reg');
}

void main() async {
  final cin = Logic();
  final reset = Logic();
  final clk = SimpleClockGenerator(10).clk;

  final shiftReg = ShiftRegister(clk, reset, cin);

  await shiftReg.build();

  reset.inject(1);
  cin.inject(bin('1101'));

  WaveDumper(shiftReg);

  Simulator.registerAction(25, () => reset.put(0));

  // Print a message when we're done with the simulation!
  Simulator.registerAction(100, () {
    print('Simulation completed!');
  });

  // Set a maximum time for the simulation so it doesn't keep running forever.
  Simulator.setMaxSimTime(100);

  // Kick off the simulation.
  await Simulator.run();
}
