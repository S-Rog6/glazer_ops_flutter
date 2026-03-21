import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  final String jobId;

  const JobDetailsPage({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Center(
        child: Text('Job Details - ID: $jobId'),
      ),
    );
  }
}
