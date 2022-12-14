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

///
class MismatchInputWidthException extends RohdException {
  ///
  MismatchInputWidthException(Logic in0, Logic in1, [String? message])
      : super(message = message ??
            'Port widths must match, '
                'but found $in0 and $in1 with different widths.');
}

///
class OneInputGateException extends RohdException {
  ///
  OneInputGateException([super.message = 'Gate has exactly one input.']);
}

///
class TwoInputGateException extends RohdException {
  ///
  TwoInputGateException([super.message = 'Gate has exactly two inputs.']);
}

///
class SingleBitException extends RohdException {
  ///
  SingleBitException(Logic control, [String? message])
      : super(
            message ?? 'Control must be single bit Logic, but found $control.');
}

///
class ThreeInputMuxException extends RohdException {
  ///
  ThreeInputMuxException([super.message = 'Mux2 has exactly three inputs.']);
}
