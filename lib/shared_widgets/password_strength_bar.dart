import 'package:flutter/material.dart';

class PasswordStrengthBar extends StatelessWidget {
  final double strength;

  const PasswordStrengthBar({Key? key, required this.strength}) : super(key: key);

  Color _strengthColor(double strength) {
    if (strength < 0.4) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: strength,
      backgroundColor: Colors.grey[300],
      color: _strengthColor(strength),
      minHeight: 8,
    );
  }
}
