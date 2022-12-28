import 'package:rohd/rohd.dart';
import 'package:test/test.dart';

FullAdderResult fullAdder(Logic a, Logic b, Logic carryIn) {
  final and1 = carryIn & (a ^ b);
  final and2 = b & a;

  final res = FullAdderResult();
  res.sum <= (a ^ b) ^ carryIn;
  res.cOut <= and1 | and2;

  return res;
}

class FullAdderResult {
  final sum = Logic(name: 'sum');
  final cOut = Logic(name: 'c_out');
}

Logic nBitAdder(Logic a, Logic b) {
  assert(a.width == b.width, 'a and b should have same width.');

  final n = a.width;
  Logic carry = Const(0);
  final sum = <Logic>[];

  for (var i = 0; i < n; i++) {
    final res = fullAdder(a[i], b[i], carry);
    carry = res.cOut;
    sum.add(res.sum);
  }

  sum.add(carry);

  return sum.rswizzle();
}

void main() {
  final a = Logic(name: 'a', width: 8);
  final b = Logic(name: 'b', width: 8);

  final sum = nBitAdder(a, b);

  test('should return 10 when both A, B equal to 5.', () async {
    a.put(5);
    b.put(5);
    print(sum.value.toString(includeWidth: false));

    expect(sum.value.toInt(), equals(10));
  });
}
