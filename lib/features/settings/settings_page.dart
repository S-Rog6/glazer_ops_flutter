import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeControllerScope.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Theme'),
                subtitle: Text(
                  themeController.isDarkMode ? 'Dark mode' : 'Light mode',
                ),
              ),
              SwitchListTile.adaptive(
                title: const Text('Use dark theme'),
                value: themeController.isDarkMode,
                onChanged: (isDarkMode) {
                  themeController.updateThemeMode(
                    isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ListTile(title: Text('Notifications')),
        const ListTile(title: Text('About')),
      ],
    );
  }
}
