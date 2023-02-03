import 'package:rohd/rohd.dart';
import '../05_combinational_logic/combinational_logic.dart';

class CarrySaveMultiplierPipeline extends Module {
  // Add Input and output port
  final List<Logic> sum =
      List.generate(7, (index) => Logic(name: 'sum_$index'));
  final List<Logic> carry =
      List.generate(8, (index) => Logic(name: 'carry_$index'));

  Logic a;
  Logic b;
  CarrySaveMultiplierPipeline(this.a, this.b, Logic clk,
      {super.name = 'carry_save_multiplier'}) {
    // Declare Input Node
    a = addInput('a', a, width: a.width);
    b = addInput('b', b, width: b.width);

    final rCarryA = Logic(width: a.width);
    final rCarryB = Logic(width: b.width);
    final nBitAdder = NBitAdder(rCarryA, rCarryB);

    final pipeline = Pipeline(
      clk,
      stages: [
        ...List.generate(
          b.width, // row
          (row) => (p) {
            final toReturnConditionals = <Conditional>[];

            // Intialize all the sum and carry to 0
            if (row == 0) {
              for (final s in sum) {
                toReturnConditionals.add(p.get(s) < 0);
              }
              for (final c in carry) {
                toReturnConditionals.add(p.get(c) < 0);
              }
            }

            // We create this from left to right, so backward loop
            // create the column / adder
            // row = 0, column = 3
            // row = 1, column = 4
            // row = 2, column = 5
            // row = 3, column = 6
            for (var column = a.width + row - 1; column >= row; column--) {
              final maxIndexA = a.width + row - 1;

              print('With Adder: row $row, column: $column');
              print('a is '
                  '${column == maxIndexA || row == 0 ? Const(0) : p.get(sum[column])}');
              print('b is '
                  '${a[column - row] & b[row]}');
              print('c is '
                  '${row == 0 ? Const(0) : p.get(carry[column - 1])}');
              print('\n');

              // wire connection
              final fa = FullAdder(
                  a: column == maxIndexA || row == 0
                      ? Const(0)
                      : p.get(sum[column]),
                  b: a[column - row] & b[row],
                  carryIn: row == 0 ? Const(0) : p.get(carry[column - 1]),
                  name: 'FA_${row}_$column');

              toReturnConditionals
                ..add(p.get(sum[column]) < fa.fullAdderRes.sum)
                ..add(p.get(carry[column]) < fa.fullAdderRes.cOut);
            }

            return toReturnConditionals;
          },
        ),
        (p) => [
              rCarryA <
                  <Logic>[
                    Const(0),
                    ...List.generate(
                        a.width - 1, (index) => p.get(sum[index + b.width]))
                  ].swizzle(),
              rCarryB <
                  <Logic>[
                    ...List.generate(
                        a.width, (index) => p.get(carry[a.width + index - 1]))
                  ].swizzle()
            ]
      ],
    );

    final product = addOutput('product', width: a.width + b.width + 1);
    final pipelineRes = addOutput('pipeline_res', width: sum.length);
    pipelineRes <=
        <Logic>[
          ...List.generate(sum.length, (index) => pipeline.get(sum[index]))
        ].swizzle();

    product <=
        <Logic>[
          ...nBitAdder.sum,
          ...List.generate(a.width, (index) => pipeline.get(sum[index]))
        ].swizzle();
  }

  Logic get product => output('product');
  Logic get sumRes => output('pipeline_res');
}

void main() async {
  final a = Logic(name: 'a', width: 4);
  final b = Logic(name: 'b', width: 4);

  final clk = SimpleClockGenerator(10).clk;

  final csm = CarrySaveMultiplierPipeline(a, b, clk);

  await csm.build();
  // print(csm.generateSynth());

  a.put(11);
  b.put(15);

  // Attach a waveform dumper so we can see what happens.
  WaveDumper(csm, outputPath: 'csm.vcd');

  Simulator.registerAction(100, () {
    print(csm.product.value.toInt());
    print(csm.sumRes.value.toString(includeWidth: false));
  });

  Simulator.setMaxSimTime(100);

  await Simulator.run();
}
