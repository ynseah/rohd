/// Copyright (C) 2022 Intel Corporation
/// SPDX-License-Identifier: BSD-3-Clause
///
/// pipeline_exceptions.dart
/// An exception that is thrown on pipeline operation.
///
/// 2022 December 13
/// Author: Yao Jing Quek <yao.jing.quek@intel.com>
///

import 'package:rohd/rohd.dart';
import 'package:rohd/src/exceptions/rohd_exception.dart';

/// An exception that thrown when bus stall signals expected to have 1 bit
/// but the incoming stall signal is not.
class MismatchSignalsException extends RohdException {
  /// Display error [message] when stall signals not equal to
  /// 1 bit.
  ///
  /// Creates a [MismatchSignalsException] with an
  /// optional error [message].
  MismatchSignalsException({required Logic stall, String? message}) {
    super.message = message ?? 'Stall signal must be 1 bit, but found $stall.';
  }
}

///
class MismatchStageNumException extends RohdException {
  ///
  MismatchStageNumException(
      {required int stallsLength, required int stageNum, String? message}) {
    super.message = message ??
        'Stall list length ($stallsLength} must match '
            'number of stages (${stageNum - 1}).';
  }
}
