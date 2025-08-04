import 'package:flutter/material.dart';

class SelectionCounterWidget extends StatelessWidget {
  final int selectedCount;
  final int maxSelection;

  const SelectionCounterWidget({
    super.key,
    required this.selectedCount,
    required this.maxSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$selectedCount/$maxSelection đã chọn",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
