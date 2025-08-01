import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class CSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.primary800),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.primary800),
        prefixIcon: const Icon(Icons.search, color: AppColors.primary800),
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.primary800),
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                )
                : null,
        filled: true,
        fillColor: AppColors.indigoNight50,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
