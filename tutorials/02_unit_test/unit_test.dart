import 'package:test/test.dart';
import 'package:rohd/rohd.dart';

void main() {
  // Let start by creating all of our port
  final Logic a = Logic(name: 'a');
  final Logic b = Logic(name: 'b');
  final Logic c = Logic(name: 'c');
  Logic sum = Logic(name: 'sum');
  Logic c_out = Logic(name: 'c_out');

  // Create the gate
  sum <= (a ^ b) ^ c;

  final and1 = c & (a ^ b);
  final and2 = b & a;
  c_out <= and1 | and2;

  test('should return 0 when A, B, C all equal 0', () async {
    a.put(0);
    b.put(0);
    c.put(0);

    expect(sum.value.toInt(), equals(0));
  });

  test('should return 1 when A equal to 0 and B, C equal to 1', () async {
    a.put(0);
    b.put(1);
    c.put(1);

    expect(c_out.value.toInt(), equals(1));
  });
}
