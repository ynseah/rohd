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

/// An exception that thrown when attempt to convert invalid logic value.
class InvalidLogicException extends RohdException {
  /// Display error [message] when [logicValue] that attempt to convert
  /// to [modName] is invalid.
  ///
  /// Creates a [InvalidLogicException] with an optional error [message].
  InvalidLogicException(
      {required String modName,
      required LogicValue logicValue,
      String? message})
      : super(message ??
            'Cannot convert invalid LogicValue to $modName: $logicValue');
}

/// An exception that thrown when attempt to convert long `width` to `int`.
class LongWidthIntException extends RohdException {
  /// Display error [message] when [width] to convert to int is too Long.
  ///
  /// Creates a [LongWidthIntException] with an optional error [message].
  LongWidthIntException(int width, [String? message])
      : super(message ??
            'LogicValue width $width is too long to convert to int.'
                ' Use toBigInt() instead.');
}

/// An exception that thrown when `LogicValue` type is invalid.
class InvalidTypeException extends RohdException {
  /// Display error [message] when [valRuntimeType] is invalid.
  ///
  /// Creates a [InvalidTypeException] with an optional error [message].
  InvalidTypeException(Type valRuntimeType)
      : super('Cannot handle type $valRuntimeType here.');
}
