import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool outlined;

  const CustomActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return outlined
        ? OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFE6DCCF),
        side: const BorderSide(color: Color(0xFF8B6F4E), width: 2),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF8B6F4E),
          fontWeight: FontWeight.bold,
        ),
      ),
    )
        : ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC9A24D),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
