import 'package:rohd/rohd.dart';

// Define a set of legal directions for this interface, and pass as parameter to Interface
enum CounterDirection { input, output }

class CounterInterface extends Interface<CounterDirection> {
  // include the getters in the interface so any user can access them
  Logic get en => port('en');
  Logic get reset => port('reset');
  Logic get val => port('val');

  final int width;
  CounterInterface(this.width) {
    // register ports to a specific direction
    setPorts([
      Port('en'), // Port extends Logic
      Port('reset')
    ], [
      CounterDirection.input
    ]); // inputs to the counter

    setPorts([
      Port('val', width),
    ], [
      CounterDirection.output
    ]); // outputs from the counter
  }
}

class Counter extends Module {
  late final CounterInterface intf;
  Counter(CounterInterface intf) {
    // define a new interface, and connect it to the interface passed in
    this.intf = CounterInterface(intf.width)
      ..connectIO(this, intf,
          // map inputs and outputs to appropriate directions
          inputTags: {CounterDirection.input},
          outputTags: {CounterDirection.output});

    var nextVal = Logic(name: 'nextVal', width: intf.width);

    // access signals directly from the interface
    nextVal <= intf.val + 1;

    Sequential(SimpleClockGenerator(10).clk, [
      If(intf.reset, then: [
        intf.val < 0
      ], orElse: [
        If(intf.en, then: [intf.val < nextVal])
      ])
    ]);
  }
}

Future<void> main() async {
  final counterInterface = CounterInterface(8);
  final counter = Counter(counterInterface);

  await counter.build();

  print(counter.generateSynth());
}
