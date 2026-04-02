class Job {
  final String id;
  final String jobName;
  final String poNumber;
  final String siteId;
  final String siteName;
  final String status;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? addressLine1;
  final String? addressLine2;
  final String? primaryContactName;
  final String? primaryContactPhone;

  Job({
    required this.id,
    required this.jobName,
    required this.poNumber,
    required this.siteId,
    required this.siteName,
    required this.status,
    required this.createdAt,
    this.startDate,
    this.endDate,
    this.addressLine1,
    this.addressLine2,
    this.primaryContactName,
    this.primaryContactPhone,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    final site = json['site'];
    final siteMap = site is Map<String, dynamic>
        ? site
        : site is Map
            ? Map<String, dynamic>.from(site)
            : const <String, dynamic>{};

    return Job(
      id: json['id'] as String,
      jobName: json['job_name'] as String,
      poNumber: json['po_number'] as String,
      siteId: json['site_id'] as String,
      siteName:
          (json['site_name'] as String?) ??
          (siteMap['name'] as String?) ??
          (json['site_id'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      startDate: _parseNullableDate(json['start_date'] as String?),
      endDate: _parseNullableDate(json['end_date'] as String?),
      addressLine1:
          (json['address_line_1'] as String?) ??
          siteMap['address_line_1'] as String?,
      addressLine2:
          (json['address_line_2'] as String?) ??
          siteMap['address_line_2'] as String?,
      primaryContactName: json['primary_contact_name'] as String?,
      primaryContactPhone: json['primary_contact_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_name': jobName,
      'po_number': poNumber,
      'site_id': siteId,
      'site_name': siteName,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'primary_contact_name': primaryContactName,
      'primary_contact_phone': primaryContactPhone,
    };
  }

  bool isActiveOn(DateTime day) {
    final target = DateTime(day.year, day.month, day.day);
    final start = startDate == null
        ? null
        : DateTime(startDate!.year, startDate!.month, startDate!.day);
    final end = endDate == null
        ? null
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    if (start == null && end == null) {
      return createdAt.year == target.year &&
          createdAt.month == target.month &&
          createdAt.day == target.day;
    }

    if (start != null && target.isBefore(start)) {
      return false;
    }

    if (end != null && target.isAfter(end)) {
      return false;
    }

    return true;
  }
}

DateTime? _parseNullableDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return DateTime.parse(value);
}
