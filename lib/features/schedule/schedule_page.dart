import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<_CalendarViewData> _views = [
    _CalendarViewData(
      title: 'Month',
      icon: Icons.calendar_month,
      description: 'High-level planning across all jobs and milestones.',
      highlights: ['Capacity heat map', 'Milestone due dates', 'Conflict alerts'],
    ),
    _CalendarViewData(
      title: 'Week',
      icon: Icons.view_week,
      description: 'Operational view for dispatch, crews, and active work windows.',
      highlights: [
        'Crew assignment lanes',
        'Travel-time buffers',
        'Shared team notes'
      ],
    ),
    _CalendarViewData(
      title: 'Day',
      icon: Icons.today,
      description: 'Execution-focused timeline with task sequencing details.',
      highlights: [
        'Hour-by-hour timeline',
        'Callout checklist',
        'Same-day handoff log'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _views.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.calendar_view_month, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Calendar Views',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBar(
            controller: _tabController,
            tabs: _views
                .map((view) => Tab(text: view.title, icon: Icon(view.icon)))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _views
                .map(
                  (view) => _CalendarViewCard(view: view),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CalendarViewCard extends StatelessWidget {
  const _CalendarViewCard({required this.view});

  final _CalendarViewData view;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(view.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(view.description),
                const SizedBox(height: 16),
                Text('Planned capabilities',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ...view.highlights.map(
                  (highlight) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(highlight)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarViewData {
  const _CalendarViewData({
    required this.title,
    required this.icon,
    required this.description,
    required this.highlights,
  });

  final String title;
  final IconData icon;
  final String description;
  final List<String> highlights;
}
