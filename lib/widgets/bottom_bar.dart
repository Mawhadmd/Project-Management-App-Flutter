import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow.withAlpha(decimal_to_alpha_colors(0.1)),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(decimal_to_alpha_colors(0.6)),
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Projects',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Friends',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
