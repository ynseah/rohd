import 'package:rohd/rohd.dart';

class ShiftRegister extends Module {
  final int width;

  ShiftRegister(Logic clk, Logic reset, Logic sin,
      {this.width = 8, super.name = 'shift_register'}) {
    // Input port
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);
    sin = addInput('s_in', sin); // shift_in

    // Output port
    final sOut = addOutput('s_out'); // need width. But why?

    // A local signal
    var rReg = Logic(name: 'r_reg', width: width); // why need width?
    var rNext = Logic(name: 'r_next', width: width);

    Sequential(clk, [
      IfBlock([
        Iff(reset, [
          rReg < 0,
        ]),
        Else([
          rReg < rNext,
        ]),
      ])
    ]);

    // assign
    rNext <= [sin, rReg.slice(width - 1, 1)].swizzle(); // right shift
    sOut <= rReg[0];
  }

  Logic get outputRes => output('s_out');
}

void main() async {
  final cin = Logic(name: 'cin');
  final reset = Logic();
  final clk = SimpleClockGenerator(10).clk;

  final shiftReg = ShiftRegister(clk, reset, cin);

  await shiftReg.build();

  // print system verilog code
  print(shiftReg.generateSynth());

  reset.inject(1);
  cin.inject(bin('1001'));

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
