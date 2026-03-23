class JobDetailsData {
  final String id;
  final String jobName;
  final String poNumber;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String siteId;
  final String siteName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String siteNotes;
  final List<JobContactData> contacts;
  final List<JobCrewAssignmentData> crewAssignments;
  final List<JobNoteData> notes;

  const JobDetailsData({
    required this.id,
    required this.jobName,
    required this.poNumber,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.siteId,
    required this.siteName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.siteNotes,
    this.contacts = const [],
    this.crewAssignments = const [],
    this.notes = const [],
  });
}

class JobContactData {
  final String name;
  final String role;
  final String phone;
  final String? email;
  final bool isPrimary;
  final String source;

  const JobContactData({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.isPrimary,
    required this.source,
  });
}

class JobCrewAssignmentData {
  final String userName;
  final DateTime workDate;
  final String status;
  final String role;
  final String? notes;

  const JobCrewAssignmentData({
    required this.userName,
    required this.workDate,
    required this.status,
    required this.role,
    required this.notes,
  });
}

class JobNoteData {
  final String authorName;
  final DateTime createdAt;
  final String content;

  const JobNoteData({
    required this.authorName,
    required this.createdAt,
    required this.content,
  });
}
