import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Settings'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
