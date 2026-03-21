import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../models/job.dart';
import 'job_card.dart';

class CardDisplayArea extends StatefulWidget {
  final String title;
  final List<Job> jobs;
  final List<Widget> actions;

  const CardDisplayArea({
    super.key,
    required this.title,
    required this.jobs,
    this.actions = const [],
  });

  @override
  State<CardDisplayArea> createState() => _CardDisplayAreaState();
}

class _CardDisplayAreaState extends State<CardDisplayArea> {
  static const String _allStatuses = 'All';

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = _allStatuses;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = <String>{
      _allStatuses,
      ...widget.jobs.map((job) => job.status),
    }.toList();
    final filteredJobs = widget.jobs.where(_matchesFilters).toList();

    return SingleChildScrollView(
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.title, style: theme.textTheme.headlineSmall),
              ),
              if (widget.actions.isNotEmpty) ...widget.actions,
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Wrap(
            spacing: AppSizes.paddingSmall,
            runSpacing: AppSizes.paddingSmall,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by job name, PO, or site',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() => _selectedStatus = value);
                },
                items: statuses
                    .map(
                      (status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
              ),
              Text(
                '${filteredJobs.length} of ${widget.jobs.length} jobs',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          if (filteredJobs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.paddingLarge,
              ),
              child: Text(
                'No jobs match the current filters.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          else
            ...filteredJobs.map((job) => JobCard(job: job)),
        ],
      ),
      ),
    );
  }

  bool _matchesFilters(Job job) {
    final query = _searchController.text.trim().toLowerCase();
    final matchesStatus =
        _selectedStatus == _allStatuses || job.status == _selectedStatus;

    if (!matchesStatus) {
      return false;
    }

    if (query.isEmpty) {
      return true;
    }

    return job.jobName.toLowerCase().contains(query) ||
        job.poNumber.toLowerCase().contains(query) ||
        job.siteId.toLowerCase().contains(query);
  }
}
