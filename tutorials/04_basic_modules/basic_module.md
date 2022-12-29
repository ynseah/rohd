# Basic Module in ROHD

## Explaination of why we need to use Module

Congratulation on making this far! 

In this tutorial, we are going to dive in on the topic `Module`s. If you have prior experience with System Verilog, they are kind of the same `Module` that we are referring. Basically, `Module` will have inputs and outputs that connects them. 

The question is why do we need a module? We had seen in previous tutorials that we can survive or use ROHD without creating module right? Well, that is because we haven't go deep to simulator or system verilog code generation. But in a typical ROHD framework, you will need `Module` to unlock capability of `generateSynth()` or `Simulation()`. Therefore, it is good to learn about ROHD module to further increase the flexibility of the hardware design. We will be using a lot of `.build()` function in the later `Sequential` circuit.

To use module, you must follow some rules here:

1. All logic **within `Module`** must consume only inputs (`input` or `addInput`) to the Module either directly or indirectly.

2. Any logic **outside `Module`** must consume the signals only via outputs (`output` or `addOutput`) of Module

3. Logic must be defined **before** the call to `super.build()`, which always must be called at the end of the build() method if it is overidden.

# First Module (one input, one output, simple logic)

Let say an example of how to create a simple ROHD module. The example below shows the simple module created with one `input` and `output`. Notice that `addInput()` and `addOutput()` is used as mentioned previously to register for input and output ports. Another things to note this the Logic of the Module `output <= input` is included inside the constructor so that `build()` instruction will pick up the Logic during the execution process.

```dart
import 'package:rohd/rohd.dart';
import 'package:test/test.dart';

class SimpleModule extends Module {
  SimpleModule(Logic input) {
    // register input port
    input = addInput(name, input);

    // register output port
    var output = addOutput('out');

    // Logic of the Module
    output <= input;
  }
}

void main() async {
  final input = Const(1);
  final simModule = SimpleModule(input);
  await simModule.build();

  test('should return input value',
      () => expect(simModule.signals.first.value.toInt(), equals(1)));
}
```

It is legal to put logic within an override of the `build` function, but that forces users of your module to always call `build` before it will be functionally usable for simple simulation. If you put logic in `build()`, ensure you put the call to `super.build()` at the end of the method.

```dart
class SimpleModule extends Module {
  // Variables are now marked as global variables
  late Logic output1;
  late final Logic input1;

  SimpleModule(Logic in1) {
    // register input port
    input1 = addInput(name, in1);

    // register output port
    output1 = addOutput('out');
  }

  @override
  Future<void> build() async {
    // Move Logic to here instead
    output1 <= input1;

    await super.build();
  }
}
```

This would still work, but you have to really be careful.

Do note that the `build()` method returns a `Future<void>`, not just `void`. This is because the `build()` method is permitted to consume real wallclock time in some cases, for example for setting up cosimulation with another simulator. If you expect your build to consume wallclock time, make sure the Simulator is aware it needs to wait before proceeding.

That all about the basic of the module! :)

## Converting to System Verilog



## Composing modules within other modules