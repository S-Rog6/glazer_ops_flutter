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
    const logoHeight = 120.0;
    const headerVerticalPadding = 18.0;
    final headerHeight = logoHeight + (headerVerticalPadding * 2);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: headerHeight,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: headerVerticalPadding,
              ),
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
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/images/Logo.png',
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.business,
                    size: logoHeight * 0.8,
                    color: colorScheme.onPrimary,
                  ),
                ),
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
        ],
      ),
    );
  }
}
