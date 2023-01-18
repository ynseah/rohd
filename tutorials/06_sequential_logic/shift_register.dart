import 'package:rohd/rohd.dart';

class ShiftRegister extends Module {
  ShiftRegister(Logic clk, Logic reset, Logic sin,
      {super.name = 'shift_register'}) {
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);
    sin = addInput('s_in', sin);

    final sout = addOutput('s_out');

    // A local signal
    final width = 4;
    var rReg = Logic(name: 'r_reg', width: width);
    var rNext = Logic(name: 'r_next', width: width);

    Sequential(clk, [
      IfBlock([
        Iff(reset, [
          rReg < 0,
        ]),
        Else([
          rReg < rNext,
        ]),
      ]),
    ]);

    rNext <= [sin, rReg.slice(width - 1, 1)].swizzle(); // right shift
    sout <= rReg[0];
  }
}

void main() async {
  final reset = Logic(name: 'reset');
  final sin = Logic(name: 's_in');
  final clk = SimpleClockGenerator(10).clk;

  final shiftReg = ShiftRegister(clk, reset, sin);
  await shiftReg.build();

  print(shiftReg.generateSynth());

  reset.inject(1);
  sin.inject(bin('101'));

  Simulator.registerAction(25, () {
    reset.put(0);
    sin.inject(bin('101'));
  });
  Simulator.registerAction(35, () {
    print(shiftReg.input('s_in').value.toString());
  });

  // Print a message when we're done with the simulation!
  Simulator.registerAction(100, () {
    print('Simulation completed!');
  });

  // Set a maximum time for the simulation so it doesn't keep running forever.
  Simulator.setMaxSimTime(100);

  WaveDumper(shiftReg,
      outputPath: 'tutorials/06_sequential_logic/shiftReg.vcd');

  // Kick off the simulation.
  await Simulator.run();
}
