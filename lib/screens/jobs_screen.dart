import 'package:flutter/material.dart';
import '../widgets/job_card.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          JobCard(
            jobName: 'Tampa Highrise',
            poNumber: 'PO-12345',
            siteName: 'Downtown Tower',
            address1: '123 Main St',
            address2: 'Tampa, FL',
            contacts: 'John (555-1234), Mike (555-5678)',
          ),
          JobCard(
            jobName: 'Hospital Install',
            poNumber: 'PO-67890',
            siteName: 'General Hospital',
            address1: '456 Medical Dr',
            address2: '',
            contacts: 'Sarah (555-9999)',
          ),
        ],
      ),
    );
  }
}