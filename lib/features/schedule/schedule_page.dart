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
                  (view) {
                    if (view.title == 'Month') {
                      return const _MonthCalendarView();
                    }
                    if (view.title == 'Week') {
                      return const _WeekCalendarView();
                    }

                    return _CalendarViewCard(view: view);
                  },
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

class _MonthCalendarView extends StatefulWidget {
  const _MonthCalendarView();

  @override
  State<_MonthCalendarView> createState() => _MonthCalendarViewState();
}

class _MonthCalendarViewState extends State<_MonthCalendarView> {
  late DateTime _displayedMonth;

  static const List<String> _weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  static const Map<int, List<String>> _jobsByDay = {
    2: ['Temple Demo'],
    4: ['South Rim Site Walk', 'Permit Follow-up'],
    7: ['Rough-in Crew A'],
    10: ['Submittal Deadline'],
    13: ['Inspection Prep', 'Client Update Call'],
    16: ['Warehouse Pickup'],
    19: ['Field Install Team B'],
    22: ['Closeout Docs'],
    25: ['Warranty Punchlist'],
    28: ['Milestone Review'],
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final monthStart = _displayedMonth;
    final monthName = _monthName(monthStart.month);
    final daysInMonth = DateUtils.getDaysInMonth(monthStart.year, monthStart.month);
    final leadingEmptyCells = monthStart.weekday % 7;
    final todayDay = now.day;
    final isCurrentMonth =
        now.year == monthStart.year && now.month == monthStart.month;

    final totalCells = leadingEmptyCells + daysInMonth;
    final trailingEmptyCells = (7 - (totalCells % 7)) % 7;
    final cellCount = totalCells + trailingEmptyCells;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      tooltip: 'Previous month',
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$monthName ${monthStart.year}',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeMonth(1),
                      tooltip: 'Next month',
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Monthly workload overview. Each chip represents a scheduled job item.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _weekdays.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) => Center(
                    child: Text(
                      _weekdays[index],
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cellCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.76,
                  ),
                  itemBuilder: (context, index) {
                    final dayNumber = index - leadingEmptyCells + 1;
                    final inMonth = dayNumber >= 1 && dayNumber <= daysInMonth;

                    if (!inMonth) {
                      return const SizedBox.shrink();
                    }

                    final jobs = _jobsByDay[dayNumber] ?? const <String>[];
                    final isToday = isCurrentMonth && dayNumber == todayDay;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          width: isToday ? 1.6 : 1,
                        ),
                        color: isToday
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
                            : theme.colorScheme.surface,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$dayNumber',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (jobs.isEmpty)
                            const Spacer()
                          else
                            Expanded(
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: jobs
                                      .map(
                                        (job) => Chip(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          labelPadding:
                                              const EdgeInsets.symmetric(horizontal: 6),
                                          visualDensity: VisualDensity.compact,
                                          label: Text(
                                            job,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return names[month - 1];
  }
}

class _WeekCalendarView extends StatefulWidget {
  const _WeekCalendarView();

  @override
  State<_WeekCalendarView> createState() => _WeekCalendarViewState();
}

class _WeekCalendarViewState extends State<_WeekCalendarView> {
  late DateTime _weekStart;

  static const Map<int, List<String>> _jobsByWeekday = {
    1: ['Morning Standup', 'Temple Demo'],
    2: ['Permit Follow-up', 'Crew A Dispatch'],
    3: ['Inspection Prep'],
    4: ['Client Update Call', 'Procurement Pickup'],
    5: ['Field Install Team B'],
    6: ['Closeout Docs'],
    7: ['On-call Window'],
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday % 7));
  }

  void _changeWeek(int deltaWeeks) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * deltaWeeks));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) => _weekStart.add(Duration(days: index)));
    final rangeLabel = '${_monthShort(weekDays.first.month)} ${weekDays.first.day} - '
        '${_monthShort(weekDays.last.month)} ${weekDays.last.day}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeWeek(-1),
                      tooltip: 'Previous week',
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          rangeLabel,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeWeek(1),
                      tooltip: 'Next week',
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Weekly dispatch view. Chips represent jobs and key tasks for each day.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ...weekDays.map(
                  (day) {
                    final weekday = day.weekday == 7 ? 7 : day.weekday;
                    final jobs = _jobsByWeekday[weekday] ?? const <String>[];
                    final isToday =
                        day.year == now.year && day.month == now.month && day.day == now.day;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          width: isToday ? 1.6 : 1,
                        ),
                        color: isToday
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : theme.colorScheme.surface,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_weekdayName(day.weekday)} ${_monthShort(day.month)} ${day.day}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (jobs.isEmpty)
                            Text(
                              'No scheduled jobs',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: jobs
                                  .map(
                                    (job) => Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      label: Text(job),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _monthShort(int month) {
    const names = [
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

    return names[month - 1];
  }

  String _weekdayName(int weekday) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return names[weekday - 1];
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
