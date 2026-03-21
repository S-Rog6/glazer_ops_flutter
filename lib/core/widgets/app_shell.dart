import 'package:flutter/material.dart';

import '../../routes/app_router.dart';
import 'app_bottom_nav.dart';
import 'app_drawer.dart';

class AppShell extends StatelessWidget {
  final String currentRoute;
  final Widget body;

  const AppShell({super.key, required this.currentRoute, required this.body});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.popUntil(context, (route) => route.isFirst);

    if (ModalRoute.of(context)?.settings.name == routeName) {
      return;
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = AppRouter.primaryIndexForRoute(currentRoute);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundWash = Color.alphaBlend(
      colorScheme.secondary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.08 : 0.05,
      ),
      theme.scaffoldBackgroundColor,
    );
    final accentWash = Color.alphaBlend(
      colorScheme.primary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.12 : 0.08,
      ),
      theme.scaffoldBackgroundColor,
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppRouter.titleForRoute(currentRoute))),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accentWash, theme.scaffoldBackgroundColor, backgroundWash],
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: currentIndex >= 0
          ? AppBottomNav(
              currentIndex: currentIndex,
              onTap: (index) {
                _navigateTo(
                  context,
                  AppRouter.primaryDestinations[index].route,
                );
              },
            )
          : null,
      drawer: AppDrawer(
        currentRoute: currentRoute,
        onDestinationSelected: (routeName) => _navigateTo(context, routeName),
      ),
    );
  }
}
