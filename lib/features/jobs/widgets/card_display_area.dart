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
    final colorScheme = theme.colorScheme;
    final statuses = <String>{
      _allStatuses,
      ...widget.jobs.map((job) => job.status),
    }.toList();
    final filteredJobs = widget.jobs.where(_matchesFilters).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final compactPhone = constraints.maxWidth < 380;
        final searchFieldWidth = compactPhone ? 250.0 : (isMobile ? 320.0 : 340.0);
        final statusFieldWidth = compactPhone ? 150.0 : 170.0;
        final panelStart = Color.alphaBlend(
          colorScheme.primary.withValues(alpha: theme.brightness == Brightness.dark ? 0.16 : 0.09),
          colorScheme.surface,
        );
        final panelEnd = Color.alphaBlend(
          colorScheme.secondary.withValues(alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06),
          colorScheme.surface,
        );
        final filterSurface = Color.alphaBlend(
          colorScheme.primary.withValues(alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08),
          colorScheme.surfaceContainerHighest,
        );

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
            AppSizes.paddingSmall,
            isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
            AppSizes.paddingLarge,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [panelStart, colorScheme.surface, panelEnd],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        if (widget.actions.isNotEmpty) ...widget.actions,
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingLarge),
                    Wrap(
                      spacing: AppSizes.paddingSmall,
                      runSpacing: AppSizes.paddingSmall,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: searchFieldWidth,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search by job name, PO, or site',
                              fillColor: filterSurface,
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
                        SizedBox(
                          width: statusFieldWidth,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              fillColor: filterSurface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '${filteredJobs.length} of ${widget.jobs.length} jobs',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingLarge),
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
            ),
          ),
        );
      },
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
