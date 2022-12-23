/// Copyright (C) 2021-2022 Intel Corporation
/// SPDX-License-Identifier: BSD-3-Clause
///
/// logic.dart
/// Definition of basic signals, like Logic, and their behavior in the
/// simulator, as well as basic operations on them
///
/// 2022 December 22
/// Author: Yao Jing Quek <yao.jing.quek@intel.com>
///

import 'package:rohd/rohd.dart';
import 'package:rohd/src/exceptions/rohd_exception.dart';

class EdgeWidthException extends RohdException {
  EdgeWidthException(
      {required String edge, required int width, String? message})
      : super(
            message ?? 'Can only detect $edge when width is 1, but was $width');
}

class LogicWidthZeroException extends RohdException {
  LogicWidthZeroException({String? message})
      : super(message ?? 'Logic width must be greater than or equal to 0.');
}

class LogicSignalConnException extends RohdException {
  LogicSignalConnException(super.message);
}

class InvalidValueException extends RohdException {
  InvalidValueException({required String val, String? message})
      : super(message ?? 'Only can fill 0 or 1, but saw $val.');
}

class InvalidPutOperationException extends RohdException {
  InvalidPutOperationException(super.message);
}

class UnassignableException extends RohdException {
  UnassignableException({required String signal, String? message})
      : super(message ??
            'This signal "$signal" has been marked as unassignable.  '
                'It may be a constant expression or otherwise'
                ' should not be assigned.');
}

class WithSetException extends RohdException {
  WithSetException(
      {required String update,
      required String startIndex,
      required String width,
      String? message})
      : super(message ??
            'Width of updatedValue $update at startIndex $startIndex would'
                ' overrun the width of the original ($width).');
}
