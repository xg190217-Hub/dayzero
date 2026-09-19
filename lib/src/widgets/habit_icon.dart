import 'package:flutter/material.dart';

import '../models/habit.dart';

/// Circular colored icon for a habit type.
class HabitIcon extends StatelessWidget {
  const HabitIcon({super.key, required this.type, this.size = 40});

  final HabitType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(type.icon, size: size * 0.55, color: type.color),
    );
  }
}
