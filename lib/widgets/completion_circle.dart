import 'package:flutter/material.dart';

class CompletionCircle extends StatelessWidget {
  final double percentage;
  final double size;
  final Color? color;

  const CompletionCircle({
    super.key,
    required this.percentage,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: color ?? Theme.of(context).primaryColor,
              strokeWidth: 3,
            ),
          ),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.30,

              color: color ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
