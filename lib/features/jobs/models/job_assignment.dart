class JobAssignment {
  final String id;
  final String jobId;
  final String userId;
  final DateTime workDate;

  const JobAssignment({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.workDate,
  });

  factory JobAssignment.fromJson(Map<String, dynamic> json) {
    return JobAssignment(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      userId: json['user_id'] as String,
      workDate: DateTime.parse(json['work_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'user_id': userId,
      'work_date': workDate.toIso8601String(),
    };
  }
}
