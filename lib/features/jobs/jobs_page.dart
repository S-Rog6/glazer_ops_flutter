import 'package:flutter/material.dart';

import 'controllers/jobs_controller.dart';
import 'widgets/card_display_area.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

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
      child: CardDisplayArea(
        title: 'Job Display Area',
        jobs: jobsController.allJobs,
        pinnedJobIds: jobsController.pinnedJobIds,
        showActiveUserToggle: jobsController.hasActiveUserContext,
        isJobForActiveUser: jobsController.hasActiveUserContext
            ? jobsController.isJobActiveForUser
            : null,
        actions: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            label: const Text('Filters'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('New Job'),
          ),
        ],
      ),
    );
  }
}
