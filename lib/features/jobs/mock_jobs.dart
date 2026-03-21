import 'models/job.dart';

final List<Job> mockJobs = [
  Job(
    id: 'job-001',
    jobName: 'Tampa Highrise',
    poNumber: 'PO-12345',
    siteId: 'Downtown Tower',
    status: 'Open',
    createdAt: DateTime(2026, 3, 15),
  ),
  Job(
    id: 'job-002',
    jobName: 'Hospital Install',
    poNumber: 'PO-67890',
    siteId: 'General Hospital',
    status: 'Scheduled',
    createdAt: DateTime(2026, 3, 13),
  ),
  Job(
    id: 'job-003',
    jobName: 'Airport Retrofit',
    poNumber: 'PO-24680',
    siteId: 'Terminal B',
    status: 'Open',
    createdAt: DateTime(2026, 3, 10),
  ),
  Job(
    id: 'job-004',
    jobName: 'University Annex',
    poNumber: 'PO-11223',
    siteId: 'North Campus',
    status: 'Completed',
    createdAt: DateTime(2026, 3, 8),
  ),
  Job(
    id: 'job-005',
    jobName: 'Civic Center Lobby',
    poNumber: 'PO-33445',
    siteId: 'Civic Center',
    status: 'In Progress',
    createdAt: DateTime.now(),
  ),
];