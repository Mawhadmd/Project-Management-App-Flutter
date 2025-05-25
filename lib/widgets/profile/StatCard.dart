import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';

Widget StatCard(
  BuildContext context,
  String title,
  Widget value,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withAlpha(decimal_to_alpha_colors(0.1)),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withAlpha(decimal_to_alpha_colors(0.2)),
        width: 1,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
       
          value,
       
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color.withAlpha(decimal_to_alpha_colors(0.8)),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
