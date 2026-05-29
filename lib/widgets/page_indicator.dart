import 'package:flutter/material.dart';
import 'app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Function(int) onTap;

  const PageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: currentIndex == index ? AppColors.primary : Colors.black26,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
