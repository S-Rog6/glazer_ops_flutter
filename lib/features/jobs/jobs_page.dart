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

    return SingleChildScrollView(
      child: CardDisplayArea(
        title: 'Job Display Area',
        jobs: jobsController.allJobs,
        showActiveUserToggle: true,
        isJobForActiveUser: jobsController.isJobActiveForUser,
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
