import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/jobs/jobs_page.dart';
import '../features/jobs/job_details_page.dart';
import '../features/schedule/schedule_page.dart';
import '../features/contacts/contacts_page.dart';
import '../features/notes/notes_page.dart';
import '../features/settings/settings_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/splash_page.dart';

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
          builder: (_) => const DashboardPage(),
        );
      case jobs:
        return MaterialPageRoute(
          builder: (_) => const JobsPage(),
        );
      case jobDetails:
        final jobId = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => JobDetailsPage(jobId: jobId),
        );
      case schedule:
        return MaterialPageRoute(
          builder: (_) => const SchedulePage(),
        );
      case contacts:
        return MaterialPageRoute(
          builder: (_) => const ContactsPage(),
        );
      case notes:
        return MaterialPageRoute(
          builder: (_) => const NotesPage(),
        );
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
