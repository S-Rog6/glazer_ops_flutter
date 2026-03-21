import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'PO# ${job.poNumber}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Chip(
              label: Text(job.status),
            ),
          ],
        ),
      ),
    );
  }
}
