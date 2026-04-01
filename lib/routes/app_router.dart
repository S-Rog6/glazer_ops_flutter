import 'package:flutter/material.dart';
import '../core/widgets/app_shell.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/jobs/jobs_page.dart';
import '../features/jobs/job_details_page.dart';
import '../features/schedule/schedule_page.dart';
import '../features/contacts/contacts_page.dart';
import '../features/notes/notes_page.dart';
import '../features/settings/settings_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/splash_page.dart';

class AppDestination {
  const AppDestination({
    required this.route,
    required this.label,
    required this.icon,
  });

  final String route;
  final String label;
  final IconData icon;
}

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String jobs = '/jobs';
  static const String jobDetails = '/job-details';
  static const String schedule = '/schedule';
  static const String contacts = '/contacts';
  static const String notes = '/notes';
  static const String settings = '/settings';

  static const List<AppDestination> primaryDestinations = [
    AppDestination(
      route: dashboard,
      label: 'Dashboard',
      icon: Icons.dashboard,
    ),
    AppDestination(
      route: jobs,
      label: 'Jobs',
      icon: Icons.work,
    ),
    AppDestination(
      route: schedule,
      label: 'Calendar Views',
      icon: Icons.calendar_view_month,
    ),
    AppDestination(
      route: contacts,
      label: 'Organization',
      icon: Icons.account_tree,
    ),
    AppDestination(
      route: settings,
      label: 'Settings',
      icon: Icons.settings,
    ),
  ];

  static const List<AppDestination> drawerDestinations = [
    ...primaryDestinations,
  ];

  static bool isShellRoute(String? routeName) {
    return drawerDestinations.any((destination) => destination.route == routeName);
  }

  static int primaryIndexForRoute(String routeName) {
    return primaryDestinations.indexWhere(
      (destination) => destination.route == routeName,
    );
  }

  static String titleForRoute(String routeName) {
    return drawerDestinations
        .firstWhere(
          (destination) => destination.route == routeName,
          orElse: () => const AppDestination(
            route: '',
            label: 'GlazerOps',
            icon: Icons.apps,
          ),
        )
        .label;
  }

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: dashboard,
            body: DashboardPage(),
          ),
        );
      case jobs:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: jobs,
            body: JobsPage(),
          ),
        );
      case jobDetails:
        final jobId = routeSettings.arguments as String?;

        if (jobId == null || jobId.isEmpty) {
          return _errorRoute('A job ID is required to open job details.');
        }

        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => JobDetailsPage(jobId: jobId),
        );
      case schedule:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: schedule,
            body: SchedulePage(),
          ),
        );
      case contacts:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: contacts,
            body: OrganizationPage(),
          ),
        );
      case notes:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: notes,
            body: NotesPage(),
          ),
        );
      case settings:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(
            currentRoute: settings,
            body: SettingsPage(),
          ),
        );
      default:
        return _errorRoute('Route not found: ${routeSettings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
