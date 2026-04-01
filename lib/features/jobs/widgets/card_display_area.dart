import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../models/job.dart';
import 'job_card.dart';

class CardDisplayArea extends StatefulWidget {
  final String title;
  final List<Job> jobs;
  final List<Widget> actions;
  final Set<String> pinnedJobIds;
  final bool showActiveUserToggle;
  final bool Function(Job job)? isJobForActiveUser;
  final String activeUserToggleLabel;

  /// Shows at most this many cards before displaying a
  /// "View More / View Less" toggle button.
  ///
  /// Defaults to 4 and supports values from 1 to 20.
  final int? maxVisibleItems;

  const CardDisplayArea({
    super.key,
    required this.title,
    required this.jobs,
    this.actions = const [],
    this.pinnedJobIds = const <String>{},
    this.showActiveUserToggle = false,
    this.isJobForActiveUser,
    this.activeUserToggleLabel = 'My jobs only',
    this.maxVisibleItems = 4,
  }) : assert(
         maxVisibleItems == null ||
             (maxVisibleItems >= 1 && maxVisibleItems <= 20),
         'maxVisibleItems must be between 1 and 20',
       );

  @override
  State<CardDisplayArea> createState() => _CardDisplayAreaState();
}

class _CardDisplayAreaState extends State<CardDisplayArea> {
  static const String _allStatuses = 'All';

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = _allStatuses;
  bool _showActiveUserOnly = false;
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CardDisplayArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasSelectedStatus = widget.jobs.any(
      (job) => job.status == _selectedStatus,
    );
    if (_selectedStatus != _allStatuses && !hasSelectedStatus) {
      _selectedStatus = _allStatuses;
    }

    if (!widget.showActiveUserToggle || widget.isJobForActiveUser == null) {
      _showActiveUserOnly = false;
    }
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
        final searchFieldWidth = compactPhone
            ? 250.0
            : (isMobile ? 320.0 : 340.0);
        final statusFieldWidth = compactPhone ? 150.0 : 170.0;
        final panelSurface = colorScheme.surface;
        final filterSurface = colorScheme.surfaceContainerHighest;

        final maxVisibleItems = widget.maxVisibleItems ?? 4;
        final hasLimit = widget.maxVisibleItems != null;
        final visibleJobs = hasLimit && !_isExpanded
            ? filteredJobs.take(maxVisibleItems).toList()
            : filteredJobs;
        final hasMore = hasLimit && filteredJobs.length > maxVisibleItems;

        final panel = Center(
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
                color: panelSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.16 : 0.05,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                            filled: true,
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
                            filled: true,
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
                      if (widget.showActiveUserToggle &&
                          widget.isJobForActiveUser != null)
                        FilterChip(
                          label: Text(widget.activeUserToggleLabel),
                          selected: _showActiveUserOnly,
                          onSelected: (value) {
                            setState(() => _showActiveUserOnly = value);
                          },
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
                    ...visibleJobs.map(
                      (job) => JobCard(
                        job: job,
                        isPinned: widget.pinnedJobIds.contains(job.id),
                      ),
                    ),
                  if (hasMore)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _isExpanded = !_isExpanded),
                        icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        label: Text(_isExpanded ? 'View Less' : 'View More'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

        if (hasLimit) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
              AppSizes.paddingSmall,
              isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
              AppSizes.paddingLarge,
            ),
            child: panel,
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
            AppSizes.paddingSmall,
            isMobile ? AppSizes.paddingSmall : AppSizes.paddingLarge,
            AppSizes.paddingLarge,
          ),
          child: panel,
        );
      },
    );
  }

  bool _matchesFilters(Job job) {
    final query = _searchController.text.trim().toLowerCase();
    final isActiveUserMatch = !_showActiveUserOnly ||
        (widget.isJobForActiveUser != null && widget.isJobForActiveUser!(job));
    final matchesStatus =
        _selectedStatus == _allStatuses || job.status == _selectedStatus;

    if (!matchesStatus || !isActiveUserMatch) {
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
