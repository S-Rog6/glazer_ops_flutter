import '../../../core/supabase/supabase_bootstrap.dart';
import '../models/job_details_data.dart';
import 'jobs_repository.dart';

class UnavailableJobsRepository implements JobsRepository {
  const UnavailableJobsRepository(this._bootstrapState);

  final SupabaseBootstrapState _bootstrapState;

  @override
  bool get isLiveDataSource => false;

  @override
  String get dataSourceLabel => _bootstrapState.isConfigured
      ? 'Supabase unavailable'
      : 'Supabase not configured';

  @override
  Future<JobsSnapshot> fetchJobs({String? activeUserId}) async {
    throw RepositoryException(_buildUnavailableMessage(resource: 'jobs'));
  }

  @override
  Future<JobDetailsData?> fetchJobDetails(String jobId) async {
    throw RepositoryException(
      _buildUnavailableMessage(resource: 'job details'),
    );
  }

  @override
  Future<RepositoryConnectionStatus> testConnection({
    String? activeUserId,
  }) async {
    final checkedAt = DateTime.now();

    if (!_bootstrapState.isConfigured) {
      return RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: false,
        isLiveDataSource: false,
        title: 'Supabase is not configured',
        message: _bootstrapState.message,
        checkedAt: checkedAt,
      );
    }

    return RepositoryConnectionStatus(
      isSuccess: false,
      isConfigured: true,
      isLiveDataSource: false,
      title: 'Supabase initialization failed',
      message: _bootstrapState.message,
      checkedAt: checkedAt,
    );
  }

  String _buildUnavailableMessage({required String resource}) {
    final nextStep = _bootstrapState.isConfigured
        ? 'Fix the Supabase initialization error and restart the app.'
        : 'Provide SUPABASE_URL and SUPABASE_ANON_KEY, then restart the app.';

    return 'Unable to load $resource because live Supabase access is unavailable. ${_bootstrapState.message} $nextStep';
  }
}
