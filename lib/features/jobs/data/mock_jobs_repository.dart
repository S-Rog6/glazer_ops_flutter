import '../../../core/supabase/supabase_bootstrap.dart';
import '../mock_job_assignments.dart';
import '../mock_job_details.dart';
import '../mock_jobs.dart';
import '../mock_user_pinned_jobs.dart';
import '../models/job_details_data.dart';
import 'jobs_repository.dart';

class MockJobsRepository implements JobsRepository {
  const MockJobsRepository();

  static const String defaultActiveUserId = scottUserId;

  @override
  bool get isLiveDataSource => false;

  @override
  String get dataSourceLabel => 'Mock data';

  @override
  Future<JobsSnapshot> fetchJobs({String? activeUserId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final resolvedUserId = activeUserId ?? defaultActiveUserId;

    return JobsSnapshot(
      jobs: mockJobs,
      pinnedJobIds: pinnedJobIdsForUser(resolvedUserId),
      assignedJobIds: assignedJobIdsForUser(resolvedUserId),
    );
  }

  @override
  Future<JobDetailsData?> fetchJobDetails(String jobId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return mockJobDetails[jobId];
  }

  @override
  Future<RepositoryConnectionStatus> testConnection({
    String? activeUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    final state = SupabaseBootstrap.state;

    if (!state.isConfigured) {
      return RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: false,
        isLiveDataSource: false,
        title: 'Supabase is not configured',
        message:
            'The app is currently running in mock mode because no Supabase URL/key was provided.',
        checkedAt: DateTime.now(),
      );
    }

    if (!state.isReady) {
      return RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: true,
        isLiveDataSource: false,
        title: 'Supabase failed to initialize',
        message: state.message,
        checkedAt: DateTime.now(),
      );
    }

    return RepositoryConnectionStatus(
      isSuccess: false,
      isConfigured: true,
      isLiveDataSource: false,
      title: 'Mock data source active',
      message:
          'Supabase appears configured, but the app is still using mock data. Restart the app to pick up the live connection.',
      checkedAt: DateTime.now(),
    );
  }
}
