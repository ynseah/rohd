import 'package:rohd/rohd.dart';

import 'counter.dart';

enum OvenStates { standby, cooking, paused, completed }

class Button extends Const {
  Button._(int super.value) : super(width: 2);
  Button.start() : this._(bin('00'));
  Button.stop() : this._(bin('01'));
  Button.resume() : this._(bin('10'));
}

class LEDLight extends Const {
  LEDLight._(int super.value) : super(width: 2);
  LEDLight.yellow() : this._(bin('00'));
  LEDLight.blue() : this._(bin('01'));
  LEDLight.red() : this._(bin('10'));
  LEDLight.green() : this._(bin('11'));
}

class OvenModule extends Module {
  OvenModule(Logic button, Logic reset) : super(name: 'OvenModule') {
    // input to FSM
    button = addInput('button', button, width: button.width);

    // output to FSM
    final led = addOutput('led', width: button.width);

    // add clock & reset
    final clk = SimpleClockGenerator(10).clk;
    reset = addInput('reset', reset);

    // add time elapsed Counter
    // final counterReset = addInput('counter_reset', Logic());
    // final en = addInput('counter_en', Logic());
    // final counter = Counter(Const(1), Const(0), clk, name: 'counter_module');

    final states = [
      State<OvenStates>(OvenStates.standby, events: {
        button.eq(Button.start()): OvenStates.cooking,
      }, actions: [
        led < LEDLight.blue().value,
      ]),
      State<OvenStates>(OvenStates.cooking, events: {
        button.eq(Button.stop()): OvenStates.paused,
        counter.val.eq(10): OvenStates.completed
      }, actions: [
        led < LEDLight.yellow().value,
      ]),
      State<OvenStates>(OvenStates.paused, events: {
        button.eq(Button.resume()): OvenStates.cooking
      }, actions: [
        led < LEDLight.red().value,
      ]),
      State<OvenStates>(OvenStates.completed, events: {
        button.eq(Button.start()): OvenStates.cooking
      }, actions: [
        led < LEDLight.green().value,
      ])
    ];

    StateMachine<OvenStates>(clk, reset, OvenStates.standby, states);
  }
}

void main() async {
  final button = Logic(name: 'button', width: 2);
  final reset = Logic(name: 'reset');

  // Create a counter Module
  final oven = OvenModule(button, reset);

  // build
  await oven.build();

  print(oven.generateSynth());

  reset.inject(1);

  Simulator.registerAction(25, () => reset.put(0));
  Simulator.registerAction(25, () {
    button.put(bin('00'));
    // oven.input('counter_reset').put(0);
    // oven.input('counter_en').put(1);
  });

  WaveDumper(oven, outputPath: 'tutorials/08_fsm/oven.vcd');

  Simulator.registerAction(100, () {
    print('Simulation End');
  });

  Simulator.setMaxSimTime(100);

  await Simulator.run();
}
