import 'package:rohd/rohd.dart';
import '../03_basic_generation/basic_generation.dart';
import '../05_combinational_logic/combinational_logic.dart';

// class CarrySaveMultiplierPipeline extends Module {
//   // Add Input and output port
//   final List<Logic> sum =
//       List.generate(7, (index) => Logic(name: 'sum_$index'));
//   final List<Logic> carry =
//       List.generate(8, (index) => Logic(name: 'carry_$index'));

//   Logic a;
//   Logic b;
//   CarrySaveMultiplierPipeline(this.a, this.b, Logic clk,
//       {super.name = 'carry_save_multiplier'}) {
//     // Declare Input Node
//     a = addInput('a', a, width: a.width);
//     b = addInput('b', b, width: b.width);

//     final rCarryA = Logic(width: a.width);
//     final rCarryB = Logic(width: b.width);
//     final nBitAdder = NBitAdder(rCarryA, rCarryB);

//     final pipeline = Pipeline(
//       clk,
//       stages: [
//         ...List.generate(
//           b.width, // row
//           (row) => (p) {
//             final toReturnConditionals = <Conditional>[];

//             // Intialize all the sum and carry to 0
//             if (row == 0) {
//               for (final s in sum) {
//                 toReturnConditionals.add(p.get(s) < 0);
//               }
//               for (final c in carry) {
//                 toReturnConditionals.add(p.get(c) < 0);
//               }
//             }

//             // We create this from left to right, so backward loop
//             // create the column / adder
//             // row = 0, column = 3
//             // row = 1, column = 4
//             // row = 2, column = 5
//             // row = 3, column = 6
//             for (var column = a.width + row - 1; column >= row; column--) {
//               final maxIndexA = a.width + row - 1;

//               print('With Adder: row $row, column: $column');
//               print('a is '
//                   '${column == maxIndexA || row == 0 ? Const(0) : p.get(sum[column])}');
//               print('b is '
//                   '${a[column - row] & b[row]}');
//               print('c is '
//                   '${row == 0 ? Const(0) : p.get(carry[column - 1])}');
//               print('\n');

//               // wire connection
//               final fa = FullAdder(
//                   a: column == maxIndexA || row == 0
//                       ? Const(0)
//                       : p.get(sum[column]),
//                   b: a[column - row] & b[row],
//                   carryIn: row == 0 ? Const(0) : p.get(carry[column - 1]),
//                   name: 'FA_${row}_$column');

//               toReturnConditionals
//                 ..add(p.get(sum[column]) < fa.fullAdderRes.sum)
//                 ..add(p.get(carry[column]) < fa.fullAdderRes.cOut);
//             }

//             return toReturnConditionals;
//           },
//         ),
//         (p) => [
//               rCarryA <
//                   <Logic>[
//                     Const(0),
//                     ...List.generate(
//                         a.width - 1, (index) => p.get(sum[index + b.width]))
//                   ].swizzle(),
//               rCarryB <
//                   <Logic>[
//                     ...List.generate(
//                         a.width, (index) => p.get(carry[a.width + index - 1]))
//                   ].swizzle()
//             ]
//       ],
//     );

//     final product = addOutput('product', width: a.width + b.width + 1);
//     final pipelineRes = addOutput('pipeline_res', width: sum.length);
//     pipelineRes <=
//         <Logic>[
//           ...List.generate(sum.length, (index) => pipeline.get(sum[index]))
//         ].swizzle();

//     product <=
//         <Logic>[
//           ...nBitAdder.sum,
//           ...List.generate(a.width, (index) => pipeline.get(sum[index]))
//         ].swizzle();
//   }

//   Logic get product => output('product');
//   Logic get sumRes => output('pipeline_res');
// }

class CarrySaveMultiplierPipelineStage extends Module {
  // Add Input and output port
  final List<Logic> sum =
      List.generate(8, (index) => Logic(name: 'sum_$index'));
  final List<Logic> carry =
      List.generate(8, (index) => Logic(name: 'carry_$index'));

  Logic a;
  Logic b;
  late final Pipeline pipeline;
  CarrySaveMultiplierPipelineStage(this.a, this.b, Logic clk,
      {super.name = 'carry_save_multiplier'}) {
    // Declare Input Node
    a = addInput('a', a, width: a.width);
    b = addInput('b', b, width: b.width);

    final rCarryA = Logic(name: 'rcarry_a', width: a.width);
    final rCarryB = Logic(name: 'rcarry_b', width: b.width);
    final nBitAdder = NBitAdder(rCarryA, rCarryB);

    final stages = [
      // row 0
      // ignore: avoid_types_on_closure_parameters
      (PipelineStageInfo p) {
        print('col 0 value a: ${a}');

        return <Conditional>[
          // column 3
          p.get(sum[3]) <
              FullAdder(a: Const(0), b: a[3] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .sum,
          p.get(carry[3]) <
              FullAdder(a: Const(0), b: a[3] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .cOut,
          // column 2
          p.get(sum[2]) <
              FullAdder(a: Const(0), b: a[2] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .sum,
          p.get(carry[2]) <
              FullAdder(a: Const(0), b: a[2] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .cOut,
          // column 1
          p.get(sum[1]) <
              FullAdder(a: Const(0), b: a[1] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .sum,
          p.get(carry[1]) <
              FullAdder(a: Const(0), b: a[1] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .cOut,
          // column 0
          p.get(sum[0]) <
              FullAdder(a: Const(0), b: a[0] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .sum,
          p.get(carry[0]) <
              FullAdder(a: Const(0), b: a[0] & b[0], carryIn: Const(0))
                  .fullAdderRes
                  .cOut,
        ];
      },
      // row 1
      // ignore: avoid_types_on_closure_parameters
      (PipelineStageInfo p) {
        final columnAdder = <Conditional>[];
        const row = 1;
        final maxIndexA = (a.width - 1) + row;

        for (var column = maxIndexA; column >= row; column--) {
          // print('a: value(p.get(sum[$column])})');
          // print('b: a[${column - row}] & b[$row]');
          // print('\n');

          final sumValue = p.get(sum[column]);
          final carryValue = p.get(carry[column - 1]);
          final fullAdder = FullAdder(
                  a: column == maxIndexA ? Const(0) : sumValue,
                  b: a[column - row] & b[row],
                  carryIn: carryValue)
              .fullAdderRes;

          // TODO: Ask Max why change the sequence of conditionals
          //will yield diff results
          columnAdder
            ..add(p.get(carry[column]) < fullAdder.cOut)
            ..add(
              p.get(sum[column]) < fullAdder.sum,
            );
        }

        return columnAdder;
      },
      // row 2
      // ignore: avoid_types_on_closure_parameters
      (PipelineStageInfo p) {
        final columnAdder = <Conditional>[];
        const row = 2;
        final maxIndexA = (a.width - 1) + row;

        for (var column = maxIndexA; column >= row; column--) {
          print('a: value(p.get(sum[$column])})');
          print('b: a[${column - row}] & b[$row]');
          print('\n');

          final sumValue = p.get(sum[column]);
          final carryValue = p.get(carry[column - 1]);
          final fullAdder = FullAdder(
                  a: column == maxIndexA ? Const(0) : sumValue,
                  b: a[column - row] & b[row],
                  carryIn: carryValue)
              .fullAdderRes;

          // TODO: Ask Max why change the sequence of conditionals
          //will yield diff results
          columnAdder
            ..add(p.get(carry[column]) < fullAdder.cOut)
            ..add(
              p.get(sum[column]) < fullAdder.sum,
            );
        }

        return columnAdder;
      },
      // row 3
      // ignore: avoid_types_on_closure_parameters
      (PipelineStageInfo p) {
        final columnAdder = <Conditional>[];
        const row = 3;
        final maxIndexA = (a.width - 1) + row;

        for (var column = maxIndexA; column >= row; column--) {
          // print('a: value(p.get(sum[$column])})');
          // print('b: a[${column - row}] & b[$row]');
          // print('\n');

          final sumValue = p.get(sum[column]);
          final carryValue = p.get(carry[column - 1]);
          final fullAdder = FullAdder(
                  a: column == maxIndexA ? Const(0) : sumValue,
                  b: a[column - row] & b[row],
                  carryIn: carryValue)
              .fullAdderRes;

          // TODO: Ask Max why change the sequence of conditionals
          //will yield diff results
          columnAdder
            ..add(p.get(carry[column]) < fullAdder.cOut)
            ..add(
              p.get(sum[column]) < fullAdder.sum,
            );
        }

        return columnAdder;
      },
      // carry ripple adder
      // ignore: avoid_types_on_closure_parameters
      (PipelineStageInfo p) => [
            rCarryA <
                <Logic>[
                  Const(0),
                  ...List.generate(a.width - 1,
                      (index) => p.get(sum[(a.width + b.width - 2) - index]))
                ].swizzle(),
            rCarryB <
                <Logic>[
                  ...List.generate(a.width,
                      (index) => p.get(carry[(a.width + b.width - 2) - index]))
                ].swizzle()
          ]
    ];

    pipeline = Pipeline(clk, stages: stages);

    final product = addOutput('product', width: a.width + b.width + 1);
    final pipelineRes = addOutput('pipeline_res', width: sum.length);
    final rippleCarryA = addOutput('rcarry_A', width: a.width);

    rippleCarryA <= rCarryA;

    pipelineRes <=
        <Logic>[
          ...List.generate(sum.length, (index) => pipeline.get(sum[index], 3))
        ].swizzle();

    final carryStage = addOutput('carry_stage', width: carry.length);
    carryStage <=
        <Logic>[
          ...List.generate(
              carry.length, (index) => pipeline.get(carry[index], 3))
        ].swizzle();

    product <=
        <Logic>[
          ...List.generate(
              a.width + 1, (index) => nBitAdder.sum[(a.width) - index]),
          // ...nBitAdder.sum,
          ...List.generate(
              a.width, (index) => pipeline.get(sum[a.width - index - 1]))
        ].swizzle();
  }

  Logic get product => output('product');
  Logic get sumRes => output('pipeline_res');
  Logic get carryRes => output('carry_stage');
  Pipeline get pipe => pipeline;

  Logic get rCarryRes => output('rcarry_A');
}

void main() async {
  final a = Logic(name: 'a', width: 4);
  final b = Logic(name: 'b', width: 4);

  final clk = SimpleClockGenerator(10).clk;

  final csm = CarrySaveMultiplierPipelineStage(a, b, clk);

  await csm.build();
  // print(csm.generateSynth());

  a.put(10);
  b.put(10);

  // Attach a waveform dumper so we can see what happens.
  WaveDumper(csm, outputPath: 'csm.vcd');

  Simulator.registerAction(200, () {
    print('Answer is ${csm.product.value.toString(includeWidth: false)}');
    print('Answer is ${csm.product.value.toInt()}');
    // print(csm.rCarryRes.value.toString(includeWidth: false));
    // LogicValue checksum = csm.pipeline.get(csm.sum[2], 0).value;

    print(csm.sumRes.value.toString(includeWidth: false));
    print(csm.carryRes.value.toString(includeWidth: false));
    // print(checksum.toString(includeWidth: false));

    //check rcarrya
    print(
        'ripple carry a: ${csm.rCarryRes.value.toString(includeWidth: false)}');
  });

  Simulator.setMaxSimTime(200);

  await Simulator.run();
}
