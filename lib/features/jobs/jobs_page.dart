import 'package:flutter/material.dart';

import 'mock_jobs.dart';
import 'widgets/card_display_area.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CardDisplayArea(
      title: 'Job Display Area',
      jobs: mockJobs,
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
    );
  }
}
