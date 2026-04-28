import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/retry.dart';
import '../models/job.dart';
import '../models/job_details_data.dart';
import 'jobs_repository.dart';

class SupabaseJobsRepository implements JobsRepository {
  SupabaseJobsRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get isLiveDataSource => true;

  @override
  String get dataSourceLabel => 'Supabase';

  @override
  Future<JobsSnapshot> fetchJobs({String? activeUserId}) async {
    try {
      return await withRetry(
        () async {
          final jobRows = _asRowList(
            await _client
                .from('jobs')
                .select(
                  '''
              id,
              job_name,
              po_number,
              site_id,
              status,
              created_at,
              start_date,
              end_date,
              site:site_id(
                name,
                address_line_1,
                address_line_2
              )
              ''',
                )
                .order('created_at', ascending: false),
          );

          final jobIds = jobRows
              .map((row) => row['id'] as String)
              .toList(growable: false);
          final siteIds = jobRows
              .map((row) => row['site_id'] as String)
              .toSet()
              .toList(growable: false);

          final primaryJobContactsFuture = _fetchPrimaryJobContacts(jobIds);
          final primarySiteContactsFuture = _fetchPrimarySiteContacts(siteIds);
          final pinnedJobIdsFuture = _fetchUserJobIds(
            table: 'user_pinned_jobs',
            activeUserId: activeUserId,
          );
          final assignedJobIdsFuture = _fetchUserJobIds(
            table: 'job_assignments',
            activeUserId: activeUserId,
          );

          final primaryJobContacts = await primaryJobContactsFuture;
          final primarySiteContacts = await primarySiteContactsFuture;
          final pinnedJobIds = await pinnedJobIdsFuture;
          final assignedJobIds = await assignedJobIdsFuture;

          final jobs = jobRows.map((row) {
            final site = _asRow(row['site']);
            final jobId = row['id'] as String;
            final siteId = row['site_id'] as String;
            final contact =
                primaryJobContacts[jobId] ?? primarySiteContacts[siteId];

            return Job(
              id: jobId,
              jobName: _readRequiredString(row, 'job_name'),
              poNumber: _readRequiredString(row, 'po_number'),
              siteId: siteId,
              siteName: _readString(site, 'name') ?? siteId,
              status: _readRequiredString(row, 'status'),
              createdAt: DateTime.parse(_readRequiredString(row, 'created_at')),
              startDate: _parseDate(_readString(row, 'start_date')),
              endDate: _parseDate(_readString(row, 'end_date')),
              addressLine1: _readString(site, 'address_line_1'),
              addressLine2: _readString(site, 'address_line_2'),
              primaryContactName: contact?.name,
              primaryContactPhone: contact?.phone,
            );
          }).toList(growable: false);

          return JobsSnapshot(
            jobs: jobs,
            pinnedJobIds: pinnedJobIds,
            assignedJobIds: assignedJobIds,
          );
        },
        retryIf: (error) => error is! PostgrestException,
      );
    } on PostgrestException catch (error) {
      throw RepositoryException(
        _formatSupabaseError(
          action: 'load jobs from Supabase',
          error: error,
        ),
      );
    } catch (error) {
      throw RepositoryException(
        'Failed to load jobs from Supabase. Error: $error',
      );
    }
  }

  @override
  Future<JobDetailsData?> fetchJobDetails(String jobId) async {
    try {
      return await withRetry(
        () async {
          final jobRow = await _client
              .from('jobs')
              .select(
                '''
            id,
            job_name,
            po_number,
            site_id,
            status,
            start_date,
            end_date,
            description,
            site:site_id(
              id,
              name,
              address_line_1,
              address_line_2,
              notes
            )
            ''',
              )
              .eq('id', jobId)
              .maybeSingle();

          if (jobRow == null) {
            return null;
          }

          final job = _asRow(jobRow);
          final site = _asRow(job['site']);
          final siteId = _readRequiredString(job, 'site_id');
          final jobStatus = _readRequiredString(job, 'status');

          final jobContactsFuture = _fetchJobContacts(jobId);
          final siteContactsFuture = _fetchSiteContacts(siteId);
          final assignmentsFuture = _fetchCrewAssignments(jobId, jobStatus);
          final notesFuture = _fetchNotes(jobId);

          final jobContacts = await jobContactsFuture;
          final siteContacts = await siteContactsFuture;
          final assignments = await assignmentsFuture;
          final notes = await notesFuture;

          return JobDetailsData(
            id: _readRequiredString(job, 'id'),
            jobName: _readRequiredString(job, 'job_name'),
            poNumber: _readRequiredString(job, 'po_number'),
            status: jobStatus,
            startDate: _parseDate(_readString(job, 'start_date')),
            endDate: _parseDate(_readString(job, 'end_date')),
            description:
                _readString(job, 'description') ?? 'No job description provided.',
            siteId: siteId,
            siteName: _readString(site, 'name') ?? siteId,
            addressLine1:
                _readString(site, 'address_line_1') ?? 'Address unavailable',
            addressLine2: _readString(site, 'address_line_2'),
            siteNotes: _readString(site, 'notes') ?? 'No site notes provided.',
            contacts: <JobContactData>[
              ...jobContacts,
              ...siteContacts,
            ],
            crewAssignments: assignments,
            notes: notes,
          );
        },
        retryIf: (error) => error is! PostgrestException,
      );
    } on PostgrestException catch (error) {
      throw RepositoryException(
        _formatSupabaseError(
          action: 'load job details from Supabase',
          error: error,
        ),
      );
    } catch (error) {
      throw RepositoryException(
        'Failed to load job details from Supabase. Error: $error',
      );
    }
  }

  @override
  Future<RepositoryConnectionStatus> testConnection({
    String? activeUserId,
  }) async {
    final checkedAt = DateTime.now();

    try {
      await _client.from('jobs').select('id').limit(1);

      if (activeUserId != null && activeUserId.trim().isNotEmpty) {
        await _client
            .from('job_assignments')
            .select('job_id')
            .eq('user_id', activeUserId)
            .limit(1);
        await _client
            .from('user_pinned_jobs')
            .select('job_id')
            .eq('user_id', activeUserId)
            .limit(1);
      }

      final scopeMessage =
          activeUserId == null || activeUserId.trim().isEmpty
              ? 'Reached Supabase and verified the base jobs query.'
              : 'Reached Supabase and verified both base jobs reads and user-scoped reads.';

      return RepositoryConnectionStatus(
        isSuccess: true,
        isConfigured: true,
        isLiveDataSource: true,
        title: 'Supabase connection OK',
        message: scopeMessage,
        checkedAt: checkedAt,
      );
    } on PostgrestException catch (error) {
      return RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: true,
        isLiveDataSource: true,
        title: 'Supabase connection failed',
        message: _formatSupabaseError(
          action: 'verify the Supabase connection',
          error: error,
        ),
        checkedAt: checkedAt,
      );
    } catch (error) {
      return RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: true,
        isLiveDataSource: true,
        title: 'Supabase connection failed',
        message: 'Unexpected error while testing Supabase. Error: $error',
        checkedAt: checkedAt,
      );
    }
  }

  Future<Map<String, _ContactSummary>> _fetchPrimaryJobContacts(
    List<String> jobIds,
  ) async {
    if (jobIds.isEmpty) {
      return const <String, _ContactSummary>{};
    }

    final rows = _asRowList(
      await _client
          .from('job_contacts')
          .select('job_id, name, phone, is_primary, sort_order')
          .inFilter('job_id', jobIds)
          .order('is_primary', ascending: false)
          .order('sort_order', ascending: true),
    );

    final contactsByJobId = <String, _ContactSummary>{};
    for (final row in rows) {
      final jobId = _readRequiredString(row, 'job_id');
      contactsByJobId.putIfAbsent(
        jobId,
        () => _ContactSummary(
          name: _readString(row, 'name'),
          phone: _readString(row, 'phone'),
        ),
      );
    }

    return contactsByJobId;
  }

  Future<Map<String, _ContactSummary>> _fetchPrimarySiteContacts(
    List<String> siteIds,
  ) async {
    if (siteIds.isEmpty) {
      return const <String, _ContactSummary>{};
    }

    final rows = _asRowList(
      await _client
          .from('site_contacts')
          .select('site_id, name, phone, is_primary')
          .inFilter('site_id', siteIds)
          .order('is_primary', ascending: false),
    );

    final contactsBySiteId = <String, _ContactSummary>{};
    for (final row in rows) {
      final siteId = _readRequiredString(row, 'site_id');
      contactsBySiteId.putIfAbsent(
        siteId,
        () => _ContactSummary(
          name: _readString(row, 'name'),
          phone: _readString(row, 'phone'),
        ),
      );
    }

    return contactsBySiteId;
  }

  Future<Set<String>> _fetchUserJobIds({
    required String table,
    String? activeUserId,
  }) async {
    if (activeUserId == null || activeUserId.trim().isEmpty) {
      return const <String>{};
    }

    try {
      final rows = _asRowList(
        await _client
            .from(table)
            .select('job_id')
            .eq('user_id', activeUserId),
      );

      return rows
          .map((row) => _readRequiredString(row, 'job_id'))
          .toSet();
    } on PostgrestException {
      return const <String>{};
    }
  }

  Future<List<JobContactData>> _fetchJobContacts(String jobId) async {
    final rows = _asRowList(
      await _client
          .from('job_contacts')
          .select('name, role, phone, email, is_primary, sort_order')
          .eq('job_id', jobId)
          .order('is_primary', ascending: false)
          .order('sort_order', ascending: true),
    );

    return rows
        .map(
          (row) => JobContactData(
            name: _readString(row, 'name') ?? 'Unknown Contact',
            role: _readString(row, 'role') ?? 'No role listed',
            phone: _readString(row, 'phone') ?? 'No phone listed',
            email: _readString(row, 'email'),
            isPrimary: row['is_primary'] == true,
            source: 'job',
          ),
        )
        .toList(growable: false);
  }

  Future<List<JobContactData>> _fetchSiteContacts(String siteId) async {
    final rows = _asRowList(
      await _client
          .from('site_contacts')
          .select('name, role, phone, email, is_primary')
          .eq('site_id', siteId)
          .order('is_primary', ascending: false),
    );

    return rows
        .map(
          (row) => JobContactData(
            name: _readString(row, 'name') ?? 'Unknown Contact',
            role: _readString(row, 'role') ?? 'No role listed',
            phone: _readString(row, 'phone') ?? 'No phone listed',
            email: _readString(row, 'email'),
            isPrimary: row['is_primary'] == true,
            source: 'site',
          ),
        )
        .toList(growable: false);
  }

  Future<List<JobCrewAssignmentData>> _fetchCrewAssignments(
    String jobId,
    String jobStatus,
  ) async {
    final rows = _asRowList(
      await _client
          .from('job_assignments')
          .select(
            '''
            work_date,
            profile:user_id(
              full_name
            )
            ''',
          )
          .eq('job_id', jobId)
          .order('work_date', ascending: true),
    );

    return rows
        .map((row) {
          final profile = _asRow(row['profile']);
          final workDate = _parseDate(_readString(row, 'work_date'));

          return JobCrewAssignmentData(
            userName: _readString(profile, 'full_name') ?? 'Unknown Crew Member',
            workDate: workDate ?? DateTime.now(),
            // The current schema has no per-assignment status or role columns,
            // so the UI derives a reasonable display value from the parent job.
            status: _displayAssignmentStatus(jobStatus),
            role: 'Crew Member',
            notes: null,
          );
        })
        .toList(growable: false);
  }

  Future<List<JobNoteData>> _fetchNotes(String jobId) async {
    final rows = _asRowList(
      await _client
          .from('notes')
          .select(
            '''
            content,
            created_at,
            author:author_user_id(
              full_name
            )
            ''',
          )
          .eq('job_id', jobId)
          .order('created_at', ascending: false),
    );

    return rows
        .map((row) {
          final author = _asRow(row['author']);
          final createdAt =
              DateTime.parse(_readRequiredString(row, 'created_at'));

          return JobNoteData(
            authorName: _readString(author, 'full_name') ?? 'Unknown Author',
            createdAt: createdAt,
            content: _readString(row, 'content') ?? '',
          );
        })
        .toList(growable: false);
  }

  String _displayAssignmentStatus(String jobStatus) {
    switch (jobStatus.trim().toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in progress':
        return 'Confirmed';
      case 'scheduled':
        return 'Assigned';
      default:
        return 'Assigned';
    }
  }
}

String _formatSupabaseError({
  required String action,
  required PostgrestException error,
}) {
  final parts = <String>[
    'Failed to $action.',
    error.message,
  ];

  if (error.code != null && error.code!.trim().isNotEmpty) {
    parts.add('Code: ${error.code}.');
  }

  if (error.hint != null && error.hint!.trim().isNotEmpty) {
    parts.add('Hint: ${error.hint}.');
  }

  final details = error.details?.toString().trim();
  if (details != null && details.isNotEmpty) {
    parts.add('Details: $details.');
  }

  if (_looksLikePolicyIssue(error)) {
    parts.add(
      'Check your Supabase RLS SELECT policies for the tables this app reads.',
    );
  }

  return parts.join(' ');
}

bool _looksLikePolicyIssue(PostgrestException error) {
  final haystack = [
    error.message,
    error.code,
    error.hint,
    error.details?.toString(),
  ].whereType<String>().join(' ').toLowerCase();

  return haystack.contains('permission denied') ||
      haystack.contains('row-level security') ||
      haystack.contains('rls');
}

class _ContactSummary {
  const _ContactSummary({
    required this.name,
    required this.phone,
  });

  final String? name;
  final String? phone;
}

List<Map<String, dynamic>> _asRowList(dynamic value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }

  return value
      .whereType<Object?>()
      .map(_asRow)
      .toList(growable: false);
}

Map<String, dynamic> _asRow(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return const <String, dynamic>{};
}

String _readRequiredString(Map<String, dynamic> row, String key) {
  final value = row[key];
  if (value is String) {
    return value;
  }

  throw StateError('Expected "$key" to be a String.');
}

String? _readString(Map<String, dynamic> row, String key) {
  final value = row[key];
  return value is String && value.trim().isNotEmpty ? value : null;
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return DateTime.parse(value);
}
