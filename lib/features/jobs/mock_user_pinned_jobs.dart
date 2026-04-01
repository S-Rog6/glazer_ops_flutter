import 'models/user_pinned_job.dart';

const String scottUserId = 'e1000000-0000-0000-0000-000000000001';

// Mirrors rows from public.user_pinned_jobs until backend reads are wired.
const List<UserPinnedJob> mockUserPinnedJobs = [
  UserPinnedJob(userId: scottUserId, jobId: 'job-001'),
  UserPinnedJob(userId: scottUserId, jobId: 'job-003'),
  UserPinnedJob(userId: 'e1000000-0000-0000-0000-000000000002', jobId: 'job-001'),
];

Set<String> pinnedJobIdsForUser(String userId) {
  return mockUserPinnedJobs
      .where((pin) => pin.userId == userId)
      .map((pin) => pin.jobId)
      .toSet();
}