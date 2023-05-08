import 'package:rohd/rohd.dart';
import '../chapter_5/n_bit_adder.dart';

class CarrySaveMultiplier extends Module {
  // Add Input and output port
  final List<Logic> sum =
      List.generate(8, (index) => Logic(name: 'sum_$index'));
  final List<Logic> carry =
      List.generate(8, (index) => Logic(name: 'carry_$index'));

  late final Pipeline pipeline;
  CarrySaveMultiplier(Logic a, Logic b, Logic clk,
      {super.name = 'carry_save_multiplier'}) {
    // Declare Input Node
    a = addInput('a', a, width: a.width);
    b = addInput('b', b, width: b.width);

    final product = addOutput('product', width: a.width + b.width + 1);
    final pipelineRes = addOutput('pipeline_res', width: sum.length);
    final rippleCarryA = addOutput('rcarry_A', width: a.width);
    final carryStage = addOutput('carry_stage', width: carry.length);

    final rCarryA = Logic(name: 'rcarry_a', width: a.width);
    final rCarryB = Logic(name: 'rcarry_b', width: b.width);

    pipeline = Pipeline(clk, stages: [
      ...List.generate(
        b.width, // how many rows to generate
        (row) => (p) {
          final columnAdder = <Conditional>[];
          final maxIndexA = (a.width - 1) + row;

          for (var column = maxIndexA; column >= row; column--) {
            final fullAdder = FullAdder(
                    a: column == maxIndexA || row == 0
                        ? Const(0)
                        : p.get(sum[column]),
                    b: a[column - row] & b[row],
                    carryIn: row == 0 ? Const(0) : p.get(carry[column - 1]))
                .fullAdderRes;

            columnAdder
              ..add(p.get(carry[column]) < fullAdder.cOut)
              ..add(
                p.get(sum[column]) < fullAdder.sum,
              );
          }

          return columnAdder;
        },
      ),
      (p) => [
            // Swizzle all the value with Const(0) + sum
            rCarryA <
                <Logic>[
                  Const(0),
                  ...List.generate(
                      a.width - 1, // a.width - 1 because the first index is 0
                      (index) => p.get(sum[(a.width + b.width - 2) - index]))
                ].swizzle(),

            // Swizzle all the value with carry
            rCarryB <
                <Logic>[
                  ...List.generate(
                      a.width, // all a.width
                      (index) => p.get(carry[(a.width + b.width - 2) - index]))
                ].swizzle()
          ]
    ]);

    rippleCarryA <= rCarryA;
    pipelineRes <=
        <Logic>[
          ...List.generate(
            sum.length,
            (index) => pipeline.get(sum[index], 3),
          )
        ].swizzle();

    carryStage <=
        <Logic>[
          ...List.generate(
            carry.length,
            (index) => pipeline.get(carry[index], 3),
          )
        ].swizzle();

    final nBitAdder = NBitAdder(rCarryA, rCarryB);

    product <=
        <Logic>[
          ...List.generate(
            a.width + 1,
            (index) => nBitAdder.sum[(a.width) - index],
          ),
          ...List.generate(
            a.width,
            (index) => pipeline.get(sum[a.width - index - 1]),
          )
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

  final csm = CarrySaveMultiplier(a, b, clk);

  await csm.build();

  a.put(12);
  b.put(2);

  // Attach a waveform dumper so we can see what happens.
  WaveDumper(csm, outputPath: 'csm.vcd');

  Simulator.registerAction(100, () {
    // print('Answer is ${csm.product.value.toString(includeWidth: false)}');
    print('Answer is ${csm.product.value.toInt()}');
    // print(csm.rCarryRes.value.toString(includeWidth: false));
    // LogicValue checksum = csm.pipeline.get(csm.sum[2], 0).value;

    // print(csm.sumRes.value.toString(includeWidth: false));
    // print(csm.carryRes.value.toString(includeWidth: false));
    // print(checksum.toString(includeWidth: false));

    // print(
    //     'ripple carry a: ${csm.rCarryRes.value.toString(includeWidth: false)}');
  });

  Simulator.setMaxSimTime(100);

  await Simulator.run();
}
