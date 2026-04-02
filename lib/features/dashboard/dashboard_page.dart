import 'package:flutter/material.dart';

import '../jobs/controllers/jobs_controller.dart';
import '../jobs/widgets/card_display_area.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsController = JobsControllerScope.of(context);

    if (jobsController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobsController.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                jobsController.errorMessage ?? 'Failed to load jobs.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: jobsController.fetchJobs,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CardDisplayArea(
            title: "Today's jobs",
            jobs: jobsController.todaysJobs,
            pinnedJobIds: jobsController.pinnedJobIds,
            showActiveUserToggle: jobsController.hasActiveUserContext,
            isJobForActiveUser: jobsController.hasActiveUserContext
                ? jobsController.isJobActiveForUser
                : null,
            maxVisibleItems: 4,
          ),
          CardDisplayArea(
            title: 'Pinned',
            jobs: jobsController.pinnedJobs,
            pinnedJobIds: jobsController.pinnedJobIds,
            maxVisibleItems: 4,
          ),
        ],
      ),
    );
  }
}
