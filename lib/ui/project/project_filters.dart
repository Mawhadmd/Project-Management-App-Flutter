import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/util/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';

class ProjectFilters extends StatelessWidget {
  final ProjectStatus? selectedStatus;
  final Function(ProjectStatus?) onStatusSelected;

  const ProjectFilters({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusSelected(null),
          ),
          const SizedBox(width: 8),
          ...ProjectStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: _getStatusLabel(status),
                isSelected: selectedStatus == status,
                onTap: () => onStatusSelected(status),
                color: _getStatusColor(status),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getStatusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.notStarted:
        return 'Not Started';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.inProgress:
        return Colors.orange;
      case ProjectStatus.onHold:
        return Colors.blue;
      case ProjectStatus.cancelled:
        return Colors.red;
      case ProjectStatus.notStarted:
        return Colors.grey;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? (color ?? Theme.of(context).colorScheme.primary)
                        .withAlpha(decimal_to_alpha_colors(0.1))
                    : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected
                      ? (color ?? Theme.of(context).colorScheme.primary)
                      : Theme.of(context).colorScheme.outline.withAlpha(
                        decimal_to_alpha_colors(0.2),
                      ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? (color ?? Theme.of(context).colorScheme.primary)
                      : Theme.of(context).colorScheme.onSurface.withAlpha(
                        decimal_to_alpha_colors(0.7),
                      ),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
