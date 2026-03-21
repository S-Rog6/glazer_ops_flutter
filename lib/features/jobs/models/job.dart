class Job {
  final String id;
  final String jobName;
  final String poNumber;
  final String siteId;
  final String status;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.jobName,
    required this.poNumber,
    required this.siteId,
    required this.status,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      jobName: json['job_name'] as String,
      poNumber: json['po_number'] as String,
      siteId: json['site_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_name': jobName,
      'po_number': poNumber,
      'site_id': siteId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
