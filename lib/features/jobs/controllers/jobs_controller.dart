import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../mock_job_assignments.dart';
import '../mock_jobs.dart';
import '../mock_user_pinned_jobs.dart';
import '../models/job.dart';

class JobsController extends ChangeNotifier {
  final String activeUserId = scottUserId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // We are currently using the mock data
  List<Job> get _allJobs => mockJobs;

  List<Job> get todaysJobs {
    final now = DateTime.now();
    return _allJobs.where((job) => _isSameDay(job.createdAt, now)).toList();
  }

  Set<String> get pinnedJobIds => pinnedJobIdsForUser(activeUserId);

  List<Job> get pinnedJobs {
    final pinnedIds = pinnedJobIds;
    return _allJobs.where((job) => pinnedIds.contains(job.id)).toList();
  }

  Set<String> get assignedJobIds => assignedJobIdsForUser(activeUserId);

  bool isJobActiveForUser(Job job) => assignedJobIds.contains(job.id);

  List<Job> get allJobs => _allJobs;

  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();

    // In the future: call API or Repository here
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
