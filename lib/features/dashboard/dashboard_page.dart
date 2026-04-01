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

    return SingleChildScrollView(
      child: Column(
        children: [
          CardDisplayArea(
            title: "Today's jobs",
            jobs: jobsController.todaysJobs,
            pinnedJobIds: jobsController.pinnedJobIds,
            showActiveUserToggle: true,
            isJobForActiveUser: jobsController.isJobActiveForUser,
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
