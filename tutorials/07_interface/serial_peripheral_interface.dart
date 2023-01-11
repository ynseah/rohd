import 'package:rohd/rohd.dart';

enum SPIDirection { fromController, fromPeripheral }

class SPIInterface extends Interface<SPIDirection> {
  // include the getter to the function
  Logic get sck => port('sck');
  Logic get mosi => port('mosi');
  Logic get miso => port('miso');
  Logic get cs => port('cs');

  SPIInterface() {
    setPorts([
      Port('sck'),
      Port('mosi'),
      Port('cs'),
    ], [
      SPIDirection.fromController
    ]);

    setPorts([
      Port('miso'),
    ], [
      SPIDirection.fromPeripheral
    ]);
  }
}

class Controller extends Module {
  late final SPIInterface interface;
  late final Logic _reset;
  late final Logic _clk;

  Controller(SPIInterface interface, Logic reset, Logic clk) {
    _reset = addInput('reset', reset);
    _clk = addInput('clk', clk);

    // define a new interface, and connect it to the interface passed in
    this.interface = SPIInterface()
      ..connectIO(
        this,
        interface,
        inputTags: {SPIDirection.fromPeripheral},
        outputTags: {SPIDirection.fromController},
      );

    _buildLogic();
  }

  void _buildLogic() {
    interface.cs <= Const(1);
    interface.sck <= _clk;

    Sequential(interface.sck, [
      IfBlock([
        Iff(_reset, [
          interface.mosi < 0,
        ]),
        Else([
          interface.mosi < ~interface.mosi,
        ]),
      ])
    ]);
  }
}

class Peripheral extends Module {
  late final SPIInterface shiftReg;

  Peripheral(SPIInterface shiftReg) {
    // define a new interface, and connect it to the interface passed in
    this.shiftReg = SPIInterface()
      ..connectIO(
        this,
        shiftReg,
        inputTags: {SPIDirection.fromController},
        outputTags: {SPIDirection.fromPeripheral},
      );

    _buildLogic();
  }

  void _buildLogic() {
    const width = 8;
    var rReg = Logic(name: 'r_reg', width: width);
    var rNext = Logic(name: 'r_next', width: width);

    Sequential(shiftReg.sck, [
      IfBlock([
        Iff(shiftReg.cs, [
          rReg < rNext,
        ]),
      ])
    ]);

    // assign
    rNext <= [shiftReg.mosi, rReg.slice(width - 1, 1)].swizzle(); // right shift
    shiftReg.miso <= rReg[0];
  }
}

class TestBench extends Module {
  final spiInterface = SPIInterface();
  final clk = SimpleClockGenerator(10).clk;

  TestBench(Logic reset) {
    reset = addInput('reset', reset);

    Controller(spiInterface, reset, clk);
    Peripheral(spiInterface);
  }
}

void main() async {
  final reset = Logic();

  final modTestBench = TestBench(reset);
  await modTestBench.build();

  print(modTestBench.generateSynth());
}
