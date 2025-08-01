import 'package:flutter/material.dart';

String? getValidatorForKeyboardType(
  TextInputType keyboardType,
  String value,
  bool isRequired,
) {
  if ((value.trim().isEmpty) && isRequired) {
    return 'Không được để trống';
  }

  if (keyboardType == TextInputType.emailAddress && isRequired) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
  }

  if (keyboardType == TextInputType.number) {
    if (int.tryParse(value) == null) {
      return 'Chỉ được nhập số';
    }
  }

  return null;
}
