import 'package:rohd/rohd.dart';

Case truthTableCase(
        Logic a, Logic b, Logic carryIn, Logic sum, Logic carryOut) =>
    Case([a, b, carryIn].swizzle(), [
      CaseItem(Const(bin('000')), [
        carryOut < 0,
      ]),
    ]);
