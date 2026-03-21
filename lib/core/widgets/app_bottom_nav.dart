import 'package:flutter/material.dart';

import '../../routes/app_router.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          theme.bottomNavigationBarTheme.backgroundColor ??
          theme.colorScheme.surface,
      selectedItemColor:
          theme.bottomNavigationBarTheme.selectedItemColor ??
          theme.colorScheme.primary,
      unselectedItemColor:
          theme.bottomNavigationBarTheme.unselectedItemColor ??
          theme.colorScheme.onSurfaceVariant,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: AppRouter.primaryDestinations
          .map(
            (destination) => BottomNavigationBarItem(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
          )
          .toList(),
    );
  }
}
