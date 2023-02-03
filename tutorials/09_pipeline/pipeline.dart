import 'package:rohd/rohd.dart';
import '../05_combinational_logic/combinational_logic.dart';

// instead of setting to list, we want to use pipeline (p) => p.get()
class CarrySaveMultiplier extends Module {
  // Add Input and output port
  Logic carry = Const(0); // the carry send to the FA

  final sum = <Logic>[Const(0), Const(0), Const(0), Const(0)];
  final carryContainer = <Logic>[
    Const(0),
    Const(0),
    Const(0),
    Const(0)
  ]; // a list with size of 4 (width of the input)
  var mulRes = <Logic>[];

  Logic a;
  Logic b;

  CarrySaveMultiplier(this.a, this.b) {
    // Declare Input Node
    a = addInput('a', a, width: a.width);
    b = addInput('b', b, width: b.width);
    carry = addInput('carry_in', carry, width: carry.width);

    final n = a.width;
    FullAdder? res;

    assert(a.width == b.width, 'a and b should have same width.');

    // for every bit in b, we want to loop it
    for (var i = 0; i < n; i++) {
      // for every bit in a, we want to multiply and create a FA
      for (var j = 0; j < n; j++) {
        // i==0 mean first row
        if (i == 0) {
          res = FullAdder(
              a: Const(0),
              b: b[i] & a[j],
              carryIn: Const(0)); // create full adder

          // if the FA is the last FA
          if (j == n - 1) {
            // get the LSB of Sum and add to the result
            mulRes.add(res.fullAdderRes.sum);

            // store the carry results as well
            carryContainer[j] = res.fullAdderRes.cOut;
          } else {
            // store the results in sum
            sum[j] = res.fullAdderRes.sum;

            // store the carry results as well
            carryContainer[j] = res.fullAdderRes.cOut;
          }
        } else {
          carry = carryContainer[j];

          if (j == 0) {
            // the first node of a input is 0
            res = FullAdder(a: Const(0), b: b[i] & a[j], carryIn: carry);

            sum[j] = res.fullAdderRes.sum;
            carryContainer[j] = res.fullAdderRes.cOut;
          } else if (j == n - 1) {
            // the last column
            res = FullAdder(a: sum[j - 1], b: b[i] & a[j], carryIn: carry);

            // add to the final result
            mulRes.add(res.fullAdderRes.sum);
            carryContainer[j] = res.fullAdderRes.cOut;
          } else {
            res = FullAdder(a: sum[j - 1], b: b[i] & a[j], carryIn: carry);

            sum[j] = res.fullAdderRes.sum;
            carryContainer[j] = res.fullAdderRes.cOut;
          }
        }
      }
    }

    final nbitAdder = NBitAdder(sum.swizzle(), carryContainer.swizzle());
    mulRes = nbitAdder.sum + mulRes;
  }

  LogicValue get multiplyRes => mulRes.rswizzle().value;
}

class CarrySaveMultiplierPipeline extends Module {
  // Add Input and output port

  final List<Logic> sum = List.generate(4 * 2, (index) => Logic());
  final List<Logic> carry = List.generate(4 * 2, (index) => Logic());

  Logic a;
  Logic b;
  CarrySaveMultiplierPipeline(this.a, this.b) {
    final clk = SimpleClockGenerator(10).clk;

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
            for (var i = a.width + row - 1; i >= row; i--) {
              final fa = FullAdder(
                  a: p.get(sum[i]),
                  b: a[i - a.width] & b[row],
                  carryIn: i == 0 ? Const(0) : p.get(carry[i - 1]));

              toReturnConditionals
                ..add(p.get(sum[i]) < fa.fullAdderRes.sum)
                ..add(p.get(carry[i]) < fa.fullAdderRes.cOut);
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
    product <=
        <Logic>[
          ...nBitAdder.sum,
          ...List.generate(a.width, (index) => pipeline.get(sum[index]))
        ].swizzle();
  }

  Logic get product => output('product');
}

void main() async {
  final a = Logic(name: 'a', width: 4);
  final b = Logic(name: 'b', width: 4);

  final csm = CarrySaveMultiplierPipeline(a, b);

  await csm.build();
  print(csm.generateSynth());

  a.put(11);
  b.put(15);

  Simulator.registerAction(100, (() {
    print(csm.product.value.toInt());
  }));

  await Simulator.run();

  // print(csm.multiplyRes.toBigInt());
}
