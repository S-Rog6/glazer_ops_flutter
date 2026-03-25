import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
    final colorScheme = theme.colorScheme;
    final barBackground =
        theme.bottomNavigationBarTheme.backgroundColor ?? colorScheme.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.secondaryDark,
                Color.alphaBlend(
                  AppColors.primary.withValues(alpha: 0.18),
                  AppColors.secondaryDark,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                height: 22,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.business,
                  size: 20,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: barBackground,
          selectedItemColor:
              theme.bottomNavigationBarTheme.selectedItemColor ??
              colorScheme.primary,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor ??
              colorScheme.onSurfaceVariant,
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
        ),
      ],
    );
  }
}
