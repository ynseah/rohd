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

/// An exception that thrown when  `width` is greater than `intBit`
/// during values conversion.
class LargeWidthException extends RohdException {
  /// Display error [message] when [width] is greater than [intBit]
  /// in [modName].
  ///
  /// Creates a [LargeWidthException] with an optional error [message].
  LargeWidthException(
      {required String modName,
      required int width,
      required int intBit,
      String? message})
      : super(message ??
            'Cannot convert to $modName when width $width'
                ' is greater than $intBit');
}

/// An exception that thrown when  `width` is greater than `intBit`
/// during values conversion.
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
