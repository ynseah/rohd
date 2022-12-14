import 'package:meta/meta.dart';

/// Copyright (C) 2022 Intel Corporation
/// SPDX-License-Identifier: BSD-3-Clause
///
/// rohd_exception.dart
/// An exception class intended to trace the exception is from ROHD.
///
/// 2022 November 17
/// Author: Yao Jing Quek <yao.jing.quek@intel.com>
///

abstract class RohdException implements Exception {
  /// The custom exception message that intent to notify user.
  final String message;

  /// Have a constructor
  RohdException(this.message);

  @override
  String toString() => message;
}
