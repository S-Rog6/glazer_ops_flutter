import 'package:flutter/widgets.dart';

import '../data/jobs_repository.dart';
import '../models/job.dart';

class JobsController extends ChangeNotifier {
  JobsController({
    required JobsRepository repository,
    this.activeUserId,
  }) : _repository = repository;

  final JobsRepository _repository;
  final String? activeUserId;

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastRefreshAttemptAt;
  DateTime? _lastSuccessfulRefreshAt;
  List<Job> _allJobs = const <Job>[];
  Set<String> _pinnedJobIds = const <String>{};
  Set<String> _assignedJobIds = const <String>{};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  DateTime? get lastRefreshAttemptAt => _lastRefreshAttemptAt;
  DateTime? get lastSuccessfulRefreshAt => _lastSuccessfulRefreshAt;
  String get dataSourceLabel => _repository.dataSourceLabel;
  bool get isLiveDataSource => _repository.isLiveDataSource;
  bool get hasActiveUserContext =>
      activeUserId != null && activeUserId!.trim().isNotEmpty;

  List<Job> get todaysJobs {
    final now = DateTime.now();
    return _allJobs.where((job) => job.isActiveOn(now)).toList();
  }

  Set<String> get pinnedJobIds => _pinnedJobIds;

  List<Job> get pinnedJobs {
    final pinnedIds = pinnedJobIds;
    return _allJobs.where((job) => pinnedIds.contains(job.id)).toList();
  }

  Set<String> get assignedJobIds => _assignedJobIds;

  bool isJobActiveForUser(Job job) => assignedJobIds.contains(job.id);

  List<Job> get allJobs => _allJobs;

  Future<bool> fetchJobs() async {
    _isLoading = true;
    _errorMessage = null;
    _lastRefreshAttemptAt = DateTime.now();
    notifyListeners();

    try {
      final snapshot = await _repository.fetchJobs(activeUserId: activeUserId);
      _allJobs = snapshot.jobs;
      _pinnedJobIds = snapshot.pinnedJobIds;
      _assignedJobIds = snapshot.assignedJobIds;
      _lastSuccessfulRefreshAt = DateTime.now();
      return true;
    } on RepositoryException catch (error) {
      _errorMessage = error.message;
    } catch (error) {
      _errorMessage = 'Failed to load jobs: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }
}

class JobsControllerScope extends InheritedNotifier<JobsController> {
  const JobsControllerScope({
    super.key,
    required JobsController controller,
    required super.child,
  }) : super(notifier: controller);

  static JobsController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<JobsControllerScope>();
    assert(scope != null, 'JobsControllerScope not found in widget tree.');
    return scope!.notifier!;
  }
}
