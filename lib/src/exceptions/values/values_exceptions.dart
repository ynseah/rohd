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
      {required String modName, required String logicValue, String? message})
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
  InvalidTypeException(Type valRuntimeType, [String? message])
      : super(message ?? 'Cannot handle type $valRuntimeType here.');
}

/// An exception that thrown when there is an unhandled scenario.
class UnhandledScenarioException extends RohdException {
  /// Display error [message] when there is an unhandled scenario.
  ///
  /// Creates a [UnhandledScenarioException] with an optional error [message].
  UnhandledScenarioException([String? message])
      : super(message ?? 'Unhandled scenario.');
}

/// An exception that thrown when comparison between runtimetype of
/// `LogicValue` is unknown.
class UnknownComparisonException extends RohdException {
  /// Display error [message] when comparison between 2 runtimetypes,
  /// [runtimeTypeLeft] and [runtimeTypeRight] is unknwon.
  ///
  /// Creates a [UnknownComparisonException] with an optional error [message].
  UnknownComparisonException(
      {required String runtimeTypeLeft,
      required String runtimeTypeRight,
      String? message})
      : super(message ??
            'Unexpected unknown comparison between $runtimeTypeLeft'
                ' and $runtimeTypeRight.');
}

/// An exception that thrown when cannot convert `width` to
/// single bit value.
class SingleBitConvertionException extends RohdException {
  /// Display error [message] when conversion of [width] to single bit
  /// value fail.
  ///
  /// Creates a [SingleBitConvertionException] with an optional error [message].
  SingleBitConvertionException({required int width, String? message})
      : super(message ??
            'Cannot convert value of width $width to a single bit value.');
}

/// An exception that thrown when width is not equal to one.
class OutputWidthException extends RohdException {
  /// Display error [message] when [newWidth] is not greater or
  /// equal to [prevWidth].
  ///
  /// Creates a [OutputWidthException] with an optional error [message].
  OutputWidthException(
      {required int newWidth, required int prevWidth, String? message})
      : super(message ??
            'New width $newWidth must be '
                'greater than or equal to width $prevWidth.');
}

/// An exception that thrown when width is not equal to one.
class SingleWidthException extends RohdException {
  /// Display error [message] when [width] is not equal to 1.
  ///
  /// Creates a [SingleWidthException] with an optional error [message].
  SingleWidthException({required int width, String? message})
      : super(message ?? 'Width must be 1, but was $width.');
}

/// An exception that thrown when conversion to boolean is fail.
class BooleanConversionException extends RohdException {
  /// Display error [message] when conversion of [value] to boolean is fail.
  ///
  /// Creates a [BooleanConversionException] with an optional error [message].
  BooleanConversionException({required LogicValue value, String? message})
      : super(message ?? 'Cannot convert value "$value" to bool.');
}

/// An exception that thrown when `width` is not equal.
class MismatchWidthException extends RohdException {
  /// Display error [message] when [widthA] and [widthB] is mismatch.
  ///
  /// Creates a [MismatchWidthException] with an optional error [message].
  MismatchWidthException(
      {required LogicValue widthA, required LogicValue widthB, String? message})
      : super(message ?? 'Widths must match, but found $widthA and $widthB');
}

/// An exception that thrown when arguments runtimeType is invalid.
class InvalidArgumentsException extends RohdException {
  /// Display error [message] when [type] is invalid.
  ///
  /// Creates a [InvalidArgumentsException] with an optional error [message].
  InvalidArgumentsException({required String type, String? message})
      : super(message ??
            'Improper arguments $type,'
                ' should be int, LogicValue, or BigInt.');
}

/// An exception that is thrown when big type is unexpected.
class InvalidBigTypeException extends RohdException {
  /// Display error [message] when Big [type] is unexpected.
  ///
  /// Creates a [InvalidBigTypeException] with an optional error [message].
  InvalidBigTypeException({required String type, String? message})
      : super(message ?? 'Unexpected big type: $type');
}

/// An exception that is thrown when edge detection value is invalid.
class EdgeDetectionException extends RohdException {
  /// Display error [message] when invalid value is found
  /// from [prevValue] to [newValue]
  ///
  /// Creates a [EdgeDetectionException] with an optional error [message].
  EdgeDetectionException(
      {required LogicValue prevValue,
      required LogicValue newValue,
      String? message})
      : super(message ??
            'Edge detection on invalid value from $prevValue to $newValue.');
}

/// An exception that is thrown when edge detection value is invalid.
class RangeException extends RohdException {
  /// Display error [message] on range related exception.
  ///
  /// Creates a [RangeException] with an error [message].
  RangeException(super.message);
}

/// An exception that is thrown when type to shift is invalid.
class InvalidShiftException extends RohdException {
  /// Display error [message] on invalid shift type.
  ///
  /// Creates a [InvalidShiftException] with an optional error [message].
  InvalidShiftException({required String type, String? message})
      : super(message ?? 'Cannot shift by type $type');
}
