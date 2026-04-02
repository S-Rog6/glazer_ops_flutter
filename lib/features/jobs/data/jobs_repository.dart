import 'package:flutter/widgets.dart';

import '../models/job.dart';
import '../models/job_details_data.dart';

class JobsSnapshot {
  const JobsSnapshot({
    required this.jobs,
    this.pinnedJobIds = const <String>{},
    this.assignedJobIds = const <String>{},
  });

  final List<Job> jobs;
  final Set<String> pinnedJobIds;
  final Set<String> assignedJobIds;
}

class RepositoryConnectionStatus {
  const RepositoryConnectionStatus({
    required this.isSuccess,
    required this.isConfigured,
    required this.isLiveDataSource,
    required this.title,
    required this.message,
    required this.checkedAt,
  });

  final bool isSuccess;
  final bool isConfigured;
  final bool isLiveDataSource;
  final String title;
  final String message;
  final DateTime checkedAt;
}

class RepositoryException implements Exception {
  const RepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class JobsRepository {
  bool get isLiveDataSource;

  String get dataSourceLabel;

  Future<JobsSnapshot> fetchJobs({String? activeUserId});

  Future<JobDetailsData?> fetchJobDetails(String jobId);

  Future<RepositoryConnectionStatus> testConnection({String? activeUserId});
}

class JobsRepositoryScope extends InheritedWidget {
  const JobsRepositoryScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final JobsRepository repository;

  static JobsRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<JobsRepositoryScope>();
    assert(scope != null, 'JobsRepositoryScope not found in widget tree.');
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(covariant JobsRepositoryScope oldWidget) {
    return repository != oldWidget.repository;
  }
}
