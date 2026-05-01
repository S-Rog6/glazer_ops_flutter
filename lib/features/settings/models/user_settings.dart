class UserSettings {
  const UserSettings({
    this.cardActionsSide = CardActionsSide.right,
    this.zoom = 1.00,
    this.scheduleView = ScheduleView.month,
    this.defaultJobsView = DefaultJobsView.card,
    this.calculatorEnabled = true,
  });

  final CardActionsSide cardActionsSide;

  /// Zoom level in the range [0.50, 2.00].
  final double zoom;

  final ScheduleView scheduleView;
  final DefaultJobsView defaultJobsView;
  final bool calculatorEnabled;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      cardActionsSide: CardActionsSide.fromValue(
        json['card_actions_side'] as String? ?? 'right',
      ),
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.00,
      scheduleView: ScheduleView.fromValue(
        json['schedule_view'] as String? ?? 'month',
      ),
      defaultJobsView: DefaultJobsView.fromValue(
        json['default_jobs_view'] as String? ?? 'card',
      ),
      calculatorEnabled: json['calculator_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_actions_side': cardActionsSide.value,
      'zoom': zoom,
      'schedule_view': scheduleView.value,
      'default_jobs_view': defaultJobsView.value,
      'calculator_enabled': calculatorEnabled,
    };
  }

  UserSettings copyWith({
    CardActionsSide? cardActionsSide,
    double? zoom,
    ScheduleView? scheduleView,
    DefaultJobsView? defaultJobsView,
    bool? calculatorEnabled,
  }) {
    return UserSettings(
      cardActionsSide: cardActionsSide ?? this.cardActionsSide,
      zoom: zoom ?? this.zoom,
      scheduleView: scheduleView ?? this.scheduleView,
      defaultJobsView: defaultJobsView ?? this.defaultJobsView,
      calculatorEnabled: calculatorEnabled ?? this.calculatorEnabled,
    );
  }
}

enum CardActionsSide {
  left('left'),
  right('right');

  const CardActionsSide(this.value);

  final String value;

  static CardActionsSide fromValue(String value) {
    return CardActionsSide.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CardActionsSide.right,
    );
  }
}

enum ScheduleView {
  month('month'),
  week('week'),
  day('day');

  const ScheduleView(this.value);

  final String value;

  static ScheduleView fromValue(String value) {
    return ScheduleView.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ScheduleView.month,
    );
  }
}

enum DefaultJobsView {
  card('card'),
  list('list'),
  table('table');

  const DefaultJobsView(this.value);

  final String value;

  static DefaultJobsView fromValue(String value) {
    return DefaultJobsView.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DefaultJobsView.card,
    );
  }
}
