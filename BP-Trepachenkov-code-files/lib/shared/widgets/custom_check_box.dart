import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;
  final double size;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? Colors.black : Colors.grey.shade400,
            width: 2,
          )
        ),
        child: value
          ? const Icon(
            Icons.check,
            size: 18,
            color: Colors.white,
            )
            : null,
      ),
    );
  }
}