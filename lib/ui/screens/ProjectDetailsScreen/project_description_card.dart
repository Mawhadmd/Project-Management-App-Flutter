import 'package:flutter/material.dart';

class ProjectDescriptionCard extends StatelessWidget {
  final String description;

  const ProjectDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withAlpha(25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(25),
            ),
          ),
          child: Text(
            description.isEmpty
                ? 'No description provided'
                : description.trim(),
            style: TextStyle(
              color:
                  description.isEmpty
                      ? Colors.grey
                      : Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
