import 'package:flutter/material.dart';

import '../jobs/mock_jobs.dart';
import '../jobs/widgets/card_display_area.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todaysJobs = mockJobs
        .where((job) => _isSameDay(job.createdAt, now))
        .toList();
    final pinnedJobs = mockJobs
        .where((job) => _pinnedJobIds.contains(job.id))
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          CardDisplayArea(
            title: "Today's jobs",
            jobs: todaysJobs,
            maxVisibleItems: 4,
          ),
          const Divider(height: 1),
          CardDisplayArea(
            title: 'Pinned',
            jobs: pinnedJobs,
            maxVisibleItems: 4,
          ),
        ],
      ),
    );
  }

  static const Set<String> _pinnedJobIds = {'job-001', 'job-003'};

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
