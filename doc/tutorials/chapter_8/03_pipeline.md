# Content

## Learning Outcome

In this chapter:

- You will learn how to use ROHD pipeline abstraction API to build carry save multiplier.

## ROHD Pipelines

ROHD has a built-in syntax for handling pipelines in a simple & refractable way. The example below shows a three-stage pipeline which adds 1 three times. Note that `Pipeline` consumes a clock and a list of stages, which are each a `List<Conditional> Function(PipelineStageInfo p)`, where `PipelineStageInfo` has information on the value of a given signal in that stage. The `List<Conditional>` the same type of procedural code that can be placed in `Combinational`.

```dart
Logic a;
var pipeline = Pipeline(clk,
  stages: [
    (p) => [
      // the first time `get` is called, `a` is automatically pipelined
      p.get(a) < p.get(a) + 1
    ],
    (p) => [
      p.get(a) < p.get(a) + 1
    ],
    (p) => [
      p.get(a) < p.get(a) + 1
    ],
  ]
);
var b = pipeline.get(a); // the output of the pipeline
```

This pipeline is very easy to refractor. If we wanted to merge the last two stages, we could simple rewrite it as:

```dart
Logic a;
var pipeline = Pipeline(clk,
  stages: [
    (p) => [
      p.get(a) < p.get(a) + 1
    ],
    (p) => [
      p.get(a) < p.get(a) + 1,
      p.get(a) < p.get(a) + 1
    ],
  ]
);
var b = pipeline.get(a);
```

You can also optionally add stalls and reset values for signals in the pipeline. Any signal not accessed via the `PipelineStageInfo` object is just accessed as normal, so other logic can optionally sit outside of the pipeline object.

ROHD also includes a version of `Pipeline` that support a ready/valid protocol called `ReadyValidPipeline`. The syntax looks the same, but has some additional parameters for readys and valids.

## Carry Save Multiplier (4 x 4)

Carry Save Multiplier is a digital circuit used for multiplying two binary numbers. It is a specialized multiplication technique that is commonly employed in high-performance arithmetic units, particularly in digital signal processing (DSP) applications.

The carry-save multiplier approach aims to enhance the speed and efficiency of the multiplication operation by breaking it down into smaller parallel operations. Instead of directly multiplying the etire multiplicand and mulltiplier, the carry-save multiplier splits them into smaller components and performs independent multiplications on each components.

We can build carry save multiplier using carry save adder built in [chapter 5](../chapter_5/00_basic_modules.md). The diagram below shows the architectures of the carry save multiplier built using Full Adder and N-Bit Adder.

![carrysave multiplier](./assets/4x4-bits-Carry-Save-Multiplier-2.png)

### Pipeline Stage

Assume that we have binary input **A = 1100** (decimal: 12) and **B = 0010** (decimal: 2). The final results would be **11000** (decimal: 24).

The **first stage** of the carry save multiplier consists of Full Adder that takes in AND gate of Ax and B0 where x is the bit position of the inputs a.

In the stage 1, the full adder takes in:

- Inputs
  - A: 0
  - B: AND(Ax, B0)
  - C-IN: 0

In the stage 2 to 4, the full adder takes:

- Inputs
  - A: Output **Sum** from previous stage
  - B: AND(Ax, By), where x is the single bit of the A, while y is the bits based on stage.
  - C-IN: Output **carry-out** from previous stage

Notice the diagram, the first index of the FA always takes in 0 as input A.
First FA

- A: 0

and the last stage is consists of the N-Bit Adder we created previously.

Let start by creating the `CarrySaveMultiplier` Module. The module takes in inputs `a`, `b` and a `clk`. Let straight away add the Inputs to the port.

```dart
class CarrySaveMultiplier extends Module {
  CarrySaveMultiplier(Logic a, Logic b, Logic clk, {super.name = 'carry_save_multiplier'}) {
    a = addInput('a', a, width: a.width);
    b = addInput('b', b, width: b.width);
  }
}
```

Since we will be using `FullAdder` and `NBitAdder` module in chapter 5. We will need to import from chapter 5.

```dart
import '../chapter_5/n_bit_adder.dart';
```

Back to our Module, we will need to declare the pipeline using `Pipeline` class. `Pipeline` takes in a clock `clk` and a list of stages. Well, we can think of every pipeline stage is a row. While every row will have `(a.width - 1) + row`.

The first stage or row of `FullAdder` will takes in 0 for `a` and `c-in`. We can also see that for every first column, the input `a` will also be 0. Therefore, we can represent `a` as `column == (a.width - 1) + row || row == 0 ? Const(0) : p.get(sum[column])`. Same goes to `carryIn`, where we can represent `carryIn` as `row == 0 ? Const(0) : p.get(carry[column - 1])`.

Note that, we use `p.get()` to get the data from previous pipeline. As for `b`, we can represent using simple `AND` operation `a[column - row] & b[row]`.

Summary:

- a: `column == (a.width - 1) + row || row == 0 ? Const(0) : p.get(sum[column])`
- b: `a[column - row] & b[row]`
- c-in: `row == 0 ? Const(0) : p.get(carry[column - 1])`

Inside the pipeline stages, we can use `...List.generate()` to generate the FullAdder.

```dart
pipeline = Pipeline(clk, stages: [
  ...List.generate(
    b.width,
    (row) => (p) {
      final columnAdder = <Conditional>[];
      final maxIndexA = (a.width - 1) + row;

      // for each of the column, we want to skip the last few column based on the current row.
      for (var column = maxIndexA; column >= row; column--) {
        final fullAdder = FullAdder(
          a: column == maxIndexA || row == 0
                        ? Const(0)
                        : p.get(sum[column]),
          b: a[column - row] & b[row], 
          carryIn: row == 0 ? Const(0) : p.get(carry[column - 1]) // Previous carry-out
        ).fullAdderRes;

        columnAdder
        ..add(p.get(carry[column]) < fullAdder.cOut)
        ..add(
          p.get(sum[column]) < fullAdder.sum,
        );
      }

      return columnAdder;
    },
  ),
]);
```

By doing this, we have successfully created stages 0 to 3. Then, we also want to manually add the last stage where we just swizzle the `sum` and `carry` and connect to `rCarryA` and `rCarryB` respectively.

