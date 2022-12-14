/// Copyright (C) 2022 Intel Corporation
/// SPDX-License-Identifier: BSD-3-Clause
///
/// values_exceptions.dart
/// An exception on values conversion.
///
/// 2022 December 14
/// Author: Yao Jing Quek <yao.jing.quek@intel.com>
///

import 'package:rohd/rohd.dart';
import 'package:rohd/src/exceptions/rohd_exception.dart';

///
class LargeWidthException extends RohdException {
  ///
  LargeWidthException(int width, int intBit, [String? message])
      : super(message ??
            'Cannot convert to BigInt when width $width'
                ' is greater than $intBit');
}

///
class InvalidLogicException extends RohdException {
  ///
  InvalidLogicException(dynamic logicValue, [String? message])
      : super(message ??
            'Cannot convert invalid LogicValue to BigInt: $logicValue');
}

///
class LongWidthException extends RohdException {
  ///
  LongWidthException(int width, [String? message])
      : super(message ??
            'LogicValue width $width is too long to convert to int.'
                ' Use toBigInt() instead.');
}

///
class InvalidTypeException extends RohdException {
  ///
  InvalidTypeException(LogicValue other)
      : super('Cannot handle type ${other.runtimeType} here.');
}
