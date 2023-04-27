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

## Carry Save Multiplier

Carry Save Multiplier is a parallel multiplier for unsigned operands. It is composed of 2-input AND gates for producing the partial products, a series of carry save adders for adding them and a ripple-carry adder for producing the final product.
