import 'package:rohd/rohd.dart';

void main() {
  // // Create input and output signals
  // final a = Logic(name: 'input_a');
  // final b = Logic(name: 'input_b');
  // final c = Logic(name: 'output_c');

  // // Create an AND logic gate
  // // This assign c to the result of a AND b
  // c <= a & b;

  // // let try with simple a = 1, b = 1
  // // a.put(1);
  // // b.put(1);
  // // print(c.value.toInt());

  // // Let build a truth table
  // for (int i = 0; i <= 1; i++) {
  //   for (int j = 0; j <= 1; j++) {
  //     a.put(i);
  //     b.put(j);
  //     print("a: $i, b: $j c: ${c.value.toInt()}");
  //   }
  // }

  var a = Logic(width: 8),
      b = Logic(width: 3),
      c = Const(7, width: 5),
      d = Logic(),
      e = Logic(width: 9);

// assign b to the bottom 3 bits of a
  b <= a.slice(2, 0);

// assign d to the top bit of a
  d <= a[7];

// construct e by swizzling bits from b, c, and d
// here, the MSB is on the left, LSB is on the right
  // e <= [d, c, b].swizzle();

// alternatively, do a reverse swizzle (useful for lists where 0-index is actually the 0th element)
// here, the LSB is on the left, the MSB is on the right
  e <= [b, c, d].rswizzle();
}
