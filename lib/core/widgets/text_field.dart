import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/utils/validator_textfield.dart';

class CustomFigmaTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool? isRequired;
  final String? Function(String?)? validator; // <- Thêm validator

  const CustomFigmaTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 339,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator:
            validator ??
            (value) => getValidatorForKeyboardType(
              keyboardType,
              value ?? '',
              isRequired ?? true,
            ),
        style: const TextStyle(
          color: Color(0xFF4F3A1D),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        cursorColor: Color(0xFF4F3A1D),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF4F3A1D),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: AppColors.brickRed400),
        ),
      ),
    );
  }
}
