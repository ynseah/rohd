import 'package:rohd/rohd.dart';

// Define a set of legal directions for SPI interface, will
// be pass as parameter to Interface
enum SPIDirection { controllerOutput, peripheralOutput }

class SPIInterface extends Interface<SPIDirection> {
  // include the getter to the function
  Logic get sck => port('sck'); // serial clock
  Logic get sdi => port('sdi'); // serial data in (mosi)
  Logic get sdo => port('sdo'); // serial data out (miso)
  Logic get cs => port('cs'); // chip select

  SPIInterface() {
    // input from controller
    setPorts([
      Port('sck'),
      Port('sdi'),
      Port('cs'),
    ], [
      SPIDirection.controllerOutput
    ]);

    // input from peripheral
    setPorts([
      Port('sdo', 8),
    ], [
      SPIDirection.peripheralOutput
    ]);
  }
}

class Controller extends Module {
  late final SPIInterface controller;
  late final Logic _reset;
  late final Logic _clk;
  late final Logic _sin;

  Controller(SPIInterface controller, Logic reset, Logic clk, Logic sin) {
    // set input port to private variable instead,
    // we don't want other class to access this
    _reset = addInput('reset', reset);
    _clk = addInput('clk', clk);
    _sin = addInput('sin', sin);

    // define a new interface, and connect it
    // to the interface passed in
    this.controller = SPIInterface()
      ..connectIO(
        this,
        controller,
        inputTags: {SPIDirection.peripheralOutput}, // Add inputs
        outputTags: {SPIDirection.controllerOutput}, // Add outputs
      );

    _buildLogic();
  }

  void _buildLogic() {
    controller.cs <= Const(1);
    controller.sck <= _clk;

    Sequential(controller.sck, [
      IfBlock([
        Iff(_reset, [
          controller.sdi < 0,
        ]),
        Else([
          controller.sdi < _sin,
        ]),
      ])
    ]);
  }
}

class ShiftRegister extends Module {
  late final SPIInterface shiftReg;

  ShiftRegister(SPIInterface shiftReg) {
    // define a new interface, and connect
    // it to the interface passed in
    this.shiftReg = SPIInterface()
      ..connectIO(
        this,
        shiftReg,
        inputTags: {SPIDirection.controllerOutput},
        outputTags: {SPIDirection.peripheralOutput},
      );

    _buildLogic();
  }

  void _buildLogic() {
    const regWidth = 8;

    // Local signal
    final data = Logic(name: 'data', width: regWidth);

    Sequential(shiftReg.sck, [
      IfBlock([
        Iff(shiftReg.cs, [
          data < [data.slice(regWidth - 2, 0), shiftReg.sdi].swizzle()
        ])
      ]),
    ]);

    // assign
    shiftReg.sdo <= data;
  }
}

class TestBench extends Module {
  Logic get sout => output('sout');

  final spiInterface = SPIInterface();
  final clk = SimpleClockGenerator(10).clk;

  TestBench(Logic reset, Logic sin) {
    reset = addInput('reset', reset);
    sin = addInput('sin', sin);
    final sout = addOutput('sout', width: 8);

    final ctrl = Controller(spiInterface, reset, clk, sin);
    final peripheral = ShiftRegister(spiInterface);

    sout <= peripheral.shiftReg.sdo;
  }
}

// TODO(Quek): How to make sure send signal and perform Simulation
void main() async {
  final reset = Logic(name: 'reset');
  final sin = Logic(name: 'sin');

  final modTestBench = TestBench(reset, sin);
  await modTestBench.build();

  print(modTestBench.generateSynth());

  Simulator.setMaxSimTime(100);

  Simulator.registerAction(25, () {
    sin.put(1);
    reset.put(0);

    print(modTestBench.sout.value.toInt());
  });
}
