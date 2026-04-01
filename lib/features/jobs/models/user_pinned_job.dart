class UserPinnedJob {
  final String userId;
  final String jobId;

  const UserPinnedJob({
    required this.userId,
    required this.jobId,
  });

  factory UserPinnedJob.fromJson(Map<String, dynamic> json) {
    return UserPinnedJob(
      userId: json['user_id'] as String,
      jobId: json['job_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'job_id': jobId,
    };
  }
}