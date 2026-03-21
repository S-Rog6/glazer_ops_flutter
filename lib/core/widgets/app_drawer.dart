import 'package:flutter/material.dart';

import '../../routes/app_router.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final ValueChanged<String> onDestinationSelected;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.9),
                  colorScheme.secondary.withValues(alpha: 0.78),
                ],
              ),
            ),
            child: Text(
              'GlazerOps',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          ...AppRouter.primaryDestinations.map(
            (destination) => ListTile(
              selected: currentRoute == destination.route,
              leading: Icon(destination.icon),
              title: Text(destination.label),
              onTap: () => onDestinationSelected(destination.route),
            ),
          ),
          const Divider(),
          ListTile(
            selected: currentRoute == AppRouter.settings,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => onDestinationSelected(AppRouter.settings),
          ),
        ],
      ),
    );
  }
}
