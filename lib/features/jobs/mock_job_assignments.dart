import 'models/job_assignment.dart';

// Mirrors rows from public.job_assignments until backend reads are wired.
final List<JobAssignment> mockJobAssignments = [
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000001',
    jobId: 'job-001',
    userId: 'e1000000-0000-0000-0000-000000000001',
    workDate: DateTime(2026, 3, 22),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000002',
    jobId: 'job-001',
    userId: 'e1000000-0000-0000-0000-000000000002',
    workDate: DateTime(2026, 3, 22),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000003',
    jobId: 'job-001',
    userId: 'e1000000-0000-0000-0000-000000000001',
    workDate: DateTime(2026, 3, 24),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000004',
    jobId: 'job-003',
    userId: 'e1000000-0000-0000-0000-000000000003',
    workDate: DateTime(2026, 3, 20),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000005',
    jobId: 'job-003',
    userId: 'e1000000-0000-0000-0000-000000000004',
    workDate: DateTime(2026, 3, 20),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000006',
    jobId: 'job-003',
    userId: 'e1000000-0000-0000-0000-000000000003',
    workDate: DateTime(2026, 3, 22),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000007',
    jobId: 'job-002',
    userId: 'e1000000-0000-0000-0000-000000000001',
    workDate: DateTime(2026, 4, 7),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000008',
    jobId: 'job-002',
    userId: 'e1000000-0000-0000-0000-000000000002',
    workDate: DateTime(2026, 4, 7),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000009',
    jobId: 'job-005',
    userId: 'e1000000-0000-0000-0000-000000000001',
    workDate: DateTime(2026, 3, 23),
  ),
  JobAssignment(
    id: 'f1000000-0000-0000-0000-000000000010',
    jobId: 'job-005',
    userId: 'e1000000-0000-0000-0000-000000000002',
    workDate: DateTime(2026, 3, 23),
  ),
];

Set<String> assignedJobIdsForUser(String userId) {
  return mockJobAssignments
      .where((assignment) => assignment.userId == userId)
      .map((assignment) => assignment.jobId)
      .toSet();
}
