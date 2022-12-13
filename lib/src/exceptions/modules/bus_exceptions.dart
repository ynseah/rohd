/// Copyright (C) 2022 Intel Corporation
/// SPDX-License-Identifier: BSD-3-Clause
///
/// bus_exceptions.dart
/// An exception that is thrown on bus operation.
///
/// 2022 December 12
/// Author: Yao Jing Quek <yao.jing.quek@intel.com>
///

import 'package:rohd/rohd.dart';
import 'package:rohd/src/exceptions/rohd_exception.dart';

/// An exception that thrown when bus `startIndex` and `endIndex` is not greater
/// or equal to zero.
class InvalidStartEndIndexException extends RohdException {
  /// Display error [message] on [startIndex] and [endIndex]
  /// which smaller than zero.
  ///
  /// Creates a [InvalidStartEndIndexException] with an
  /// optional error [message].
  InvalidStartEndIndexException(
      {required int startIndex, required int endIndex, String? message}) {
    super.message = message ??
        'Start ($startIndex) and End ($endIndex) must '
            'be greater than or equal to 0.';
  }
}

/// An exception that thrown when bus index is out of bound.
class InvalidOutOfBoundIndexException extends RohdException {
  /// Display error [message] on index out of bound which indicate [startIndex]
  /// and [endIndex] must be less than [width].
  ///
  /// Creates a [InvalidOutOfBoundIndexException] with an
  /// optional error [message].
  InvalidOutOfBoundIndexException(
      {required int startIndex,
      required int endIndex,
      required int width,
      String? message}) {
    super.message = message ??
        'Index out of bounds, indices $startIndex and $endIndex must be less'
            ' than $width';
  }
}

/// An exception that thrown when custom verilog inputs
/// to be injected more than one.
class InvalidMultipleInputException extends RohdException {
  /// Display error [message] on when [inputs] expected to be
  /// only one in bus subset.
  ///
  /// Creates a [InvalidMultipleInputException] with an
  /// optional error [message].
  InvalidMultipleInputException(
      {required Map<String, String> inputs, String? message}) {
    super.message = message ?? 'Object has exactly one input, but saw $inputs.';
  }
}

/// An exception that thrown when swizzle input length
/// and not same as inputs length.
class InvalidLengthException extends RohdException {
  /// Display error [message] on length mismatch between [swizzleInputs] and
  /// [inputs].
  ///
  /// Creates a [InvalidLengthException] with an optional error [message].
  InvalidLengthException(
      {required List<Logic> swizzleInputs,
      required Map<String, String> inputs,
      String? message}) {
    super.message = message ??
        'This swizzle has ${swizzleInputs.length} inputs,'
            ' but saw $inputs with ${inputs.length} values.';
  }
}
