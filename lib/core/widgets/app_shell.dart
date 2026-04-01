import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;
    final showBottomNav = isMobile && currentIndex >= 0;
    final showDrawer = !isMobile;
    final isDark = theme.brightness == Brightness.dark;
    final topWash = Color.alphaBlend(
      (isDark ? AppColors.darkWashMaroon : AppColors.primary).withValues(
        alpha: isDark ? 0.18 : 0.04,
      ),
      theme.scaffoldBackgroundColor,
    );
    final bottomWash = Color.alphaBlend(
      (isDark ? AppColors.secondaryDark : AppColors.secondary).withValues(
        alpha: isDark ? 0.10 : 0.025,
      ),
      theme.scaffoldBackgroundColor,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 22,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.business,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 10),
            Text(AppRouter.titleForRoute(currentRoute)),
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [topWash, theme.scaffoldBackgroundColor, bottomWash],
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: showBottomNav
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
      drawer: showDrawer
          ? AppDrawer(
              currentRoute: currentRoute,
              onDestinationSelected: (routeName) =>
                  _navigateTo(context, routeName),
            )
          : null,
    );
  }
}
