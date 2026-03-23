import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import 'mock_job_details.dart';
import 'models/job_details_data.dart';

class JobDetailsPage extends StatelessWidget {
  final String jobId;

  const JobDetailsPage({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    final job = mockJobDetails[jobId] ?? _fallbackJob(jobId);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topWash = Color.alphaBlend(
      colorScheme.primary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08,
      ),
      theme.scaffoldBackgroundColor,
    );
    final bottomWash = Color.alphaBlend(
      colorScheme.secondary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.10 : 0.05,
      ),
      theme.scaffoldBackgroundColor,
    );

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(job.jobName),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Contacts'),
              Tab(text: 'Crew'),
              Tab(text: 'Notes'),
              Tab(text: 'Attachments'),
            ],
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [topWash, theme.scaffoldBackgroundColor, bottomWash],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 860;

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _JobHeaderCard(job: job),
                          const SizedBox(height: AppSizes.paddingLarge),
                          SizedBox(
                            height: 760,
                            child: TabBarView(
                              children: [
                                _OverviewTab(job: job),
                                _ContactsTab(job: job),
                                _CrewTab(job: job),
                                _NotesTab(job: job),
                                _AttachmentsTab(job: job),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  JobDetailsData _fallbackJob(String id) {
    return JobDetailsData(
      id: id,
      jobName: 'Job $id',
      poNumber: 'PO-UNKNOWN',
      status: 'Open',
      startDate: DateTime(2026, 3, 23),
      endDate: DateTime(2026, 3, 30),
      description: 'Mock job details are not configured for this job yet.',
      siteId: 'site-unknown',
      siteName: 'Unknown Site',
      addressLine1: 'Address unavailable',
      addressLine2: null,
      city: 'Unknown',
      state: '--',
      postalCode: '-----',
      siteNotes: 'Add mock detail data when this job is wired to backend views.',
    );
  }
}

class _JobHeaderCard extends StatelessWidget {
  final JobDetailsData job;

  const _JobHeaderCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(colorScheme, job.status);
    final isDark = theme.brightness == Brightness.dark;
    final headerStart = Color.alphaBlend(
      statusColor.withValues(alpha: isDark ? 0.16 : 0.08),
      colorScheme.surface,
    );
    final headerEnd = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: isDark ? 0.14 : 0.07),
      colorScheme.surface,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [headerStart, colorScheme.surface, headerEnd],
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 900;
            final summary = _JobSummary(job: job, statusColor: statusColor);
            final infoRail = _QuickInfoRail(job: job, statusColor: statusColor);

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  summary,
                  const SizedBox(height: AppSizes.paddingLarge),
                  infoRail,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                const SizedBox(width: AppSizes.paddingLarge),
                SizedBox(width: 300, child: infoRail),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JobSummary extends StatelessWidget {
  final JobDetailsData job;
  final Color statusColor;

  const _JobSummary({required this.job, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final metaBackground = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: isDark ? 0.14 : 0.08),
      colorScheme.surfaceContainerHighest,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.jobName,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Text(
          job.description,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetaChip(
              icon: Icons.sell_outlined,
              label: job.poNumber,
              backgroundColor: metaBackground,
            ),
            _MetaChip(
              icon: Icons.location_on_outlined,
              label: job.siteName,
              backgroundColor: metaBackground,
            ),
            _StatusChip(label: job.status, color: statusColor),
          ],
        ),
        const SizedBox(height: AppSizes.paddingLarge),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricTile(
              label: 'Start',
              value: _formatDate(job.startDate),
              icon: Icons.event_available_outlined,
            ),
            _MetricTile(
              label: 'Finish',
              value: _formatDate(job.endDate),
              icon: Icons.event_busy_outlined,
            ),
            _MetricTile(
              label: 'Contacts',
              value: '${job.contacts.length}',
              icon: Icons.contact_phone_outlined,
            ),
            _MetricTile(
              label: 'Crew Days',
              value: '${job.crewAssignments.length}',
              icon: Icons.groups_outlined,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickInfoRail extends StatelessWidget {
  final JobDetailsData job;
  final Color statusColor;

  const _QuickInfoRail({required this.job, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final panelColor = Color.alphaBlend(
      statusColor.withValues(alpha: theme.brightness == Brightness.dark ? 0.10 : 0.05),
      colorScheme.surfaceContainerHighest,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSizes.paddingMedium),
            _InfoRow(icon: Icons.badge_outlined, label: 'Site ID', value: job.siteId),
            const SizedBox(height: AppSizes.paddingSmall),
            _InfoRow(
              icon: Icons.pin_drop_outlined,
              label: 'Address',
              value: _formatAddress(job),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            _InfoRow(icon: Icons.sticky_note_2_outlined, label: 'Access', value: job.siteNotes),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final JobDetailsData job;

  const _OverviewTab({required this.job});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'Job overview',
          icon: Icons.work_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailLine(label: 'Job name', value: job.jobName),
              _DetailLine(label: 'PO number', value: job.poNumber),
              _DetailLine(label: 'Status', value: job.status),
              _DetailLine(label: 'Schedule window', value: '${_formatDate(job.startDate)} → ${_formatDate(job.endDate)}'),
              _DetailLine(label: 'Description', value: job.description),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingLarge),
        _SectionCard(
          title: 'Site information',
          icon: Icons.location_city_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailLine(label: 'Site name', value: job.siteName),
              _DetailLine(label: 'Address', value: _formatAddress(job)),
              _DetailLine(label: 'Site notes', value: job.siteNotes),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactsTab extends StatelessWidget {
  final JobDetailsData job;

  const _ContactsTab({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.contacts.isEmpty) {
      return const _EmptyState(
        icon: Icons.contact_phone_outlined,
        title: 'No contacts yet',
        message: 'Job and site contacts will appear here once they are available.',
      );
    }

    return ListView.separated(
      itemCount: job.contacts.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.paddingMedium),
      itemBuilder: (context, index) {
        final contact = job.contacts[index];

        return _SectionCard(
          title: contact.name,
          icon: Icons.person_outline,
          trailing: Wrap(
            spacing: 8,
            children: [
              if (contact.isPrimary) const _SmallBadge(label: 'Primary'),
              _SmallBadge(label: contact.source == 'job' ? 'Job contact' : 'Site contact'),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailLine(label: 'Role', value: contact.role),
              _DetailLine(label: 'Phone', value: contact.phone),
              _DetailLine(label: 'Email', value: contact.email ?? 'Not provided'),
            ],
          ),
        );
      },
    );
  }
}

class _CrewTab extends StatelessWidget {
  final JobDetailsData job;

  const _CrewTab({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.crewAssignments.isEmpty) {
      return const _EmptyState(
        icon: Icons.groups_outlined,
        title: 'No crew assignments yet',
        message: 'Per-day staffing from the calendar view will show here.',
      );
    }

    return ListView.separated(
      itemCount: job.crewAssignments.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.paddingMedium),
      itemBuilder: (context, index) {
        final assignment = job.crewAssignments[index];
        final colorScheme = Theme.of(context).colorScheme;

        return _SectionCard(
          title: assignment.userName,
          icon: Icons.construction_outlined,
          trailing: _StatusChip(
            label: assignment.status,
            color: _statusColor(colorScheme, assignment.status),
            dense: true,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailLine(label: 'Work date', value: _formatDate(assignment.workDate)),
              _DetailLine(label: 'Role', value: assignment.role),
              _DetailLine(label: 'Notes', value: assignment.notes ?? 'No notes for this assignment.'),
            ],
          ),
        );
      },
    );
  }
}

class _NotesTab extends StatelessWidget {
  final JobDetailsData job;

  const _NotesTab({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.notes.isEmpty) {
      return const _EmptyState(
        icon: Icons.note_alt_outlined,
        title: 'No notes yet',
        message: 'Field updates, blockers, and handoff notes will appear here.',
      );
    }

    return ListView.separated(
      itemCount: job.notes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.paddingMedium),
      itemBuilder: (context, index) {
        final note = job.notes[index];

        return _SectionCard(
          title: note.authorName,
          icon: Icons.note_outlined,
          trailing: Text(_formatDateTime(note.createdAt)),
          child: Text(
            note.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        );
      },
    );
  }
}

class _AttachmentsTab extends StatelessWidget {
  final JobDetailsData job;

  const _AttachmentsTab({required this.job});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Attachments placeholder',
      icon: Icons.attach_file_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachments are intentionally a placeholder in this first pass. The backend schema docs defer a real attachments table until the upload flow is defined.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSizes.paddingLarge),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _PlaceholderTile(
                icon: Icons.photo_library_outlined,
                title: 'Photos',
                message: 'Future upload area for job progress photos.',
              ),
              _PlaceholderTile(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Documents',
                message: 'Future upload area for permits, drawings, and PDFs.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: title,
      icon: icon,
      child: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconMedium),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: colorScheme.outline),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: colorScheme.outline)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool dense;

  const _StatusChip({
    required this.label,
    required this.color,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.12),
        shape: StadiumBorder(
          side: BorderSide(color: color.withValues(alpha: isDark ? 0.36 : 0.24)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 12 : 16,
          vertical: dense ? 6 : 8,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;

  const _SmallBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outline),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _PlaceholderTile({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: colorScheme.outline),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
        ],
      ),
    );
  }
}

Color _statusColor(ColorScheme colorScheme, String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return colorScheme.primary;
    case 'scheduled':
      return colorScheme.secondary;
    case 'completed':
      return const Color(0xFF6B7A8A);
    case 'in progress':
    case 'confirmed':
      return const Color(0xFF7090A8);
    case 'assigned':
      return const Color(0xFF8A7D58);
    default:
      return colorScheme.primary;
  }
}

String _formatAddress(JobDetailsData job) {
  final lines = [job.addressLine1, if (job.addressLine2 != null) job.addressLine2!];
  final cityStatePostal = '${job.city}, ${job.state} ${job.postalCode}';
  return [...lines, cityStatePostal].join('\n');
}

String _formatDate(DateTime value) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${monthNames[value.month - 1]} ${value.day}, ${value.year}';
}

String _formatDateTime(DateTime value) {
  final hour = value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final meridiem = value.hour >= 12 ? 'PM' : 'AM';
  return '${_formatDate(value)} · $hour:$minute $meridiem';
}
