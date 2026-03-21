import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';
import 'app_drawer.dart';

class AppShell extends StatefulWidget {
  final Widget body;

  const AppShell({
    super.key,
    required this.body,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlazerOps'),
      ),
      body: widget.body,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      drawer: const AppDrawer(),
    );
  }
}
