import 'package:rohd/rohd.dart';
import '../05_combinational_logic/combinational_logic.dart';

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

void main() async {
  final a = Logic(name: 'a', width: 4);
  final b = Logic(name: 'b', width: 4);

  // final csm = CarrySaveMultiplier(a, b);

  // await csm.build();

  final nbitAdderTest = CarrySaveMultiplier(a, b);

  await nbitAdderTest.build();

  a.put(11);
  b.put(15);

  print(nbitAdderTest.multiplyRes.toBigInt());
}
