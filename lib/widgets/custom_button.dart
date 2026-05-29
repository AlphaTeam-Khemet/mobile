import 'package:flutter/material.dart';
import 'app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isFullWidth;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : 65,
        height: isFullWidth ? 50 : 65,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: isFullWidth ? BorderRadius.circular(12) : null,
          shape: isFullWidth ? BoxShape.rectangle : BoxShape.circle,
        ),
        child: Center(
          child: isFullWidth
              ? Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
              : const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
