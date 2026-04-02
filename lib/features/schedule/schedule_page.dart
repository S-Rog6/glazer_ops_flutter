import 'package:flutter/material.dart';

import '../../routes/app_router.dart';
import '../jobs/controllers/jobs_controller.dart';
import '../jobs/models/job.dart';
import '../jobs/widgets/card_display_area.dart';

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

List<Job> _scheduledJobsForDate(DateTime date, List<Job> jobs) {
  final scheduledJobs = jobs
      .where((job) => job.isActiveOn(date))
      .toList(growable: false);
  scheduledJobs.sort(_compareJobsForSchedule);
  return scheduledJobs;
}

DateTime _startOfWeek(DateTime value) {
  final date = _dateOnly(value);
  return date.subtract(Duration(days: date.weekday % 7));
}

int _compareJobsForSchedule(Job left, Job right) {
  final leftDate = left.startDate ?? left.createdAt;
  final rightDate = right.startDate ?? right.createdAt;
  final byDate = leftDate.compareTo(rightDate);
  if (byDate != 0) {
    return byDate;
  }

  return left.jobName.compareTo(right.jobName);
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late DateTime _selectedDay;

  static const List<_CalendarViewData> _views = [
    _CalendarViewData(
      title: 'Month',
      icon: Icons.calendar_month,
      description: 'High-level planning across all jobs and milestones.',
      highlights: [
        'Capacity heat map',
        'Milestone due dates',
        'Conflict alerts',
      ],
    ),
    _CalendarViewData(
      title: 'Week',
      icon: Icons.view_week,
      description:
          'Operational view for dispatch, crews, and active work windows.',
      highlights: [
        'Crew assignment lanes',
        'Travel-time buffers',
        'Shared team notes',
      ],
    ),
    _CalendarViewData(
      title: 'Day',
      icon: Icons.today,
      description: 'Execution-focused timeline with task sequencing details.',
      highlights: [
        'Hour-by-hour timeline',
        'Callout checklist',
        'Same-day handoff log',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _tabController = TabController(length: _views.length, vsync: this);
  }

  void _selectDay(DateTime day, {bool openDayTab = false}) {
    setState(() {
      _selectedDay = _dateOnly(day);
    });

    if (openDayTab) {
      _tabController.animateTo(2);
    }
  }

  void _changeSelectedDay(int deltaDays) {
    _selectDay(_selectedDay.add(Duration(days: deltaDays)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsController = JobsControllerScope.of(context);
    if (jobsController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobsController.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                jobsController.errorMessage ?? 'Failed to load schedule.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: jobsController.fetchJobs,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final jobs = jobsController.allJobs;
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
            children: _views.map((view) {
              if (view.title == 'Month') {
                return _MonthCalendarView(
                  jobs: jobs,
                  selectedDay: _selectedDay,
                  onDaySelected: (day) => _selectDay(day, openDayTab: true),
                );
              }
              if (view.title == 'Week') {
                return _WeekCalendarView(
                  jobs: jobs,
                  selectedDay: _selectedDay,
                  onDaySelected: (day) => _selectDay(day, openDayTab: true),
                );
              }

              if (view.title == 'Day') {
                return _DayCalendarView(
                  jobs: jobs,
                  pinnedJobIds: jobsController.pinnedJobIds,
                  showActiveUserToggle: jobsController.hasActiveUserContext,
                  isJobForActiveUser: jobsController.hasActiveUserContext
                      ? jobsController.isJobActiveForUser
                      : null,
                  selectedDay: _selectedDay,
                  onChangeDay: _changeSelectedDay,
                );
              }

              return _CalendarViewCard(view: view);
            }).toList(),
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
                Text(
                  'Planned capabilities',
                  style: theme.textTheme.titleMedium,
                ),
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
  const _MonthCalendarView({
    required this.jobs,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<Job> jobs;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

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

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      1,
    );
  }

  @override
  void didUpdateWidget(covariant _MonthCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameMonth(oldWidget.selectedDay, widget.selectedDay)) {
      _displayedMonth = DateTime(
        widget.selectedDay.year,
        widget.selectedDay.month,
        1,
      );
    }
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
    final daysInMonth = DateUtils.getDaysInMonth(
      monthStart.year,
      monthStart.month,
    );
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

                    final dayDate = DateTime(
                      monthStart.year,
                      monthStart.month,
                      dayNumber,
                    );
                    final jobs = _scheduledJobsForDate(dayDate, widget.jobs);
                    final isToday = isCurrentMonth && dayNumber == todayDay;
                    final isSelected = _isSameDate(dayDate, widget.selectedDay);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => widget.onDaySelected(dayDate),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected || isToday
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              width: isSelected || isToday ? 1.6 : 1,
                            ),
                            color: isSelected
                                ? theme.colorScheme.secondaryContainer
                                : isToday
                                ? theme.colorScheme.primaryContainer.withValues(
                                    alpha: 0.35,
                                  )
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
                                            (job) => ActionChip(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              labelPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                  ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () =>
                                                  _openJobDetails(context, job),
                                              label: Text(
                                                job.jobName,
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
                        ),
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

  bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool _isSameMonth(DateTime left, DateTime right) {
    return left.year == right.year && left.month == right.month;
  }
}

class _WeekCalendarView extends StatefulWidget {
  const _WeekCalendarView({
    required this.jobs,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<Job> jobs;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  State<_WeekCalendarView> createState() => _WeekCalendarViewState();
}

class _WeekCalendarViewState extends State<_WeekCalendarView> {
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = _startOfWeek(widget.selectedDay);
  }

  @override
  void didUpdateWidget(covariant _WeekCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameDate(oldWidget.selectedDay, widget.selectedDay)) {
      _weekStart = _startOfWeek(widget.selectedDay);
    }
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
    final weekDays = List.generate(
      7,
      (index) => _weekStart.add(Duration(days: index)),
    );
    final rangeLabel =
        '${_monthShort(weekDays.first.month)} ${weekDays.first.day} - '
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
                ...weekDays.map((day) {
                  final jobs = _scheduledJobsForDate(day, widget.jobs);
                  final isToday =
                      day.year == now.year &&
                      day.month == now.month &&
                      day.day == now.day;
                  final isSelected = _isSameDate(day, widget.selectedDay);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => widget.onDaySelected(day),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected || isToday
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: isSelected || isToday ? 1.6 : 1,
                          ),
                          color: isSelected
                              ? theme.colorScheme.secondaryContainer
                              : isToday
                              ? theme.colorScheme.primaryContainer.withValues(
                                  alpha: 0.3,
                                )
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
                                      (job) => ActionChip(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () =>
                                            _openJobDetails(context, job),
                                        label: Text(job.jobName),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return names[weekday - 1];
  }

  bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _DayCalendarView extends StatefulWidget {
  const _DayCalendarView({
    required this.jobs,
    required this.pinnedJobIds,
    required this.showActiveUserToggle,
    required this.isJobForActiveUser,
    required this.selectedDay,
    required this.onChangeDay,
  });

  final List<Job> jobs;
  final Set<String> pinnedJobIds;
  final bool showActiveUserToggle;
  final bool Function(Job job)? isJobForActiveUser;
  final DateTime selectedDay;
  final ValueChanged<int> onChangeDay;

  @override
  State<_DayCalendarView> createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<_DayCalendarView> {
  String _titleForDay(DateTime day) {
    return '${_weekdayName(day.weekday)}, ${_monthShort(day.month)} ${day.day}, ${day.year}';
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _scheduledJobsForDate(widget.selectedDay, widget.jobs);

    return SingleChildScrollView(
      child: CardDisplayArea(
        title: _titleForDay(widget.selectedDay),
        jobs: jobs,
        pinnedJobIds: widget.pinnedJobIds,
        showActiveUserToggle: widget.showActiveUserToggle,
        isJobForActiveUser: widget.isJobForActiveUser,
        maxVisibleItems: 4,
        actions: [
          IconButton(
            onPressed: () => widget.onChangeDay(-1),
            tooltip: 'Previous day',
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: () => widget.onChangeDay(1),
            tooltip: 'Next day',
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
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
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return names[weekday - 1];
  }
}

void _openJobDetails(BuildContext context, Job job) {
  Navigator.of(context).pushNamed(AppRouter.jobDetails, arguments: job.id);
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
