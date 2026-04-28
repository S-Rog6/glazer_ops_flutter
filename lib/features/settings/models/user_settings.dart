class UserSettings {
  const UserSettings({
    this.cardActionsSide = CardActionsSide.right,
    this.zoom = 1.00,
    this.scheduleView = ScheduleView.month,
    this.calculatorEnabled = true,
  });

  final CardActionsSide cardActionsSide;

  /// Zoom level in the range [0.50, 2.00].
  final double zoom;

  final ScheduleView scheduleView;
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
      calculatorEnabled: json['calculator_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_actions_side': cardActionsSide.value,
      'zoom': zoom,
      'schedule_view': scheduleView.value,
      'calculator_enabled': calculatorEnabled,
    };
  }

  UserSettings copyWith({
    CardActionsSide? cardActionsSide,
    double? zoom,
    ScheduleView? scheduleView,
    bool? calculatorEnabled,
  }) {
    return UserSettings(
      cardActionsSide: cardActionsSide ?? this.cardActionsSide,
      zoom: zoom ?? this.zoom,
      scheduleView: scheduleView ?? this.scheduleView,
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
