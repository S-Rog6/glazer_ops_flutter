import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';

class GlazerOpsApp extends StatelessWidget {
  const GlazerOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlazerOps',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
