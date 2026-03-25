import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
                  AppColors.secondaryDark,
                  Color.alphaBlend(
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.secondaryDark,
                  ),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.business,
                    size: 56,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
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
