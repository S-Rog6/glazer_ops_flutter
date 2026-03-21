import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.surface,
            ),
            child: Text(
              'GlazerOps',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Jobs'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to jobs
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to schedule
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to contacts
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Notes'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to notes
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
