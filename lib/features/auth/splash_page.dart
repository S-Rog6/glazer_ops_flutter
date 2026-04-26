import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/supabase/supabase_bootstrap.dart';
import '../../routes/app_router.dart';

// const bool kBypassLogin = true;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextRoute = _resolveNextRoute();
        Navigator.of(context).pushReplacementNamed(
          nextRoute,
        );
      }
    });
  }

  String _resolveNextRoute() {
    try {
      if (!SupabaseBootstrap.state.isReady) {
        return AppRouter.login;
      }

      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        return AppRouter.dashboard;
      }

      return AppRouter.login;
    } catch (_) {
      return AppRouter.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.darkBackground, AppColors.darkSurface],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.business,
                  size: 96,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 28.0),
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
