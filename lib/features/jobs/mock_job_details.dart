import 'models/job_details_data.dart';

final Map<String, JobDetailsData> mockJobDetails = {
  'job-001': JobDetailsData(
    id: 'job-001',
    jobName: 'Tampa Highrise',
    poNumber: 'PO-12345',
    status: 'In Progress',
    startDate: DateTime(2026, 3, 17),
    endDate: DateTime(2026, 3, 28),
    description:
        'Install new tempered storefront glass panels on floors 1–3, including framing adjustments and sealant work.',
    siteId: 'site-001',
    siteName: 'Downtown Office Tower',
    addressLine1: '123 N Michigan Ave',
    addressLine2: 'Suite 100, Chicago, IL 60601',
    siteNotes:
        'High-rise access requires security check-in 30 minutes before arrival. Badge needed for upper floors.',
    contacts: const [
      JobContactData(
        name: 'Larry Hennessy',
        role: 'Facilities Manager',
        phone: '312-555-0101',
        email: 'l.hennessy@downtowntower.com',
        isPrimary: true,
        source: 'job',
      ),
      JobContactData(
        name: 'Carol Vance',
        role: 'Security Desk',
        phone: '312-555-0102',
        email: null,
        isPrimary: false,
        source: 'site',
      ),
    ],
    crewAssignments: [
      JobCrewAssignmentData(
        userName: 'Scott Rogers',
        workDate: DateTime(2026, 3, 22),
        status: 'Confirmed',
        role: 'Lead Glazier',
        notes: null,
      ),
      JobCrewAssignmentData(
        userName: 'Mike Deluca',
        workDate: DateTime(2026, 3, 22),
        status: 'Confirmed',
        role: 'Glazier',
        notes: null,
      ),
      JobCrewAssignmentData(
        userName: 'Scott Rogers',
        workDate: DateTime(2026, 3, 24),
        status: 'Assigned',
        role: 'Lead Glazier',
        notes: null,
      ),
    ],
    notes: [
      JobNoteData(
        authorName: 'Scott Rogers',
        createdAt: DateTime(2026, 3, 22, 8, 15),
        content:
            'Framing on floors 1 and 2 is complete. Floor 3 framing starts tomorrow and glass delivery is confirmed for Monday.',
      ),
      JobNoteData(
        authorName: 'Mike Deluca',
        createdAt: DateTime(2026, 3, 22, 11, 45),
        content:
            'Existing sill plates on floor 2 are out of level. Flagged for shimming review before panel install.',
      ),
    ],
  ),
  'job-002': JobDetailsData(
    id: 'job-002',
    jobName: 'Hospital Install',
    poNumber: 'PO-67890',
    status: 'Scheduled',
    startDate: DateTime(2026, 4, 7),
    endDate: DateTime(2026, 4, 18),
    description:
        'Curtain wall repair package with scaffold coordination and phased glazing replacement.',
    siteId: 'site-002',
    siteName: 'Riverside Medical Center',
    addressLine1: '450 River Rd',
    addressLine2: 'Chicago, IL 60607',
    siteNotes:
        'Hospital campus rules apply. Use south delivery entrance and avoid noisy work after 8 PM.',
    contacts: const [
      JobContactData(
        name: 'Marcus Webb',
        role: 'Plant Operations',
        phone: '312-555-0201',
        email: 'm.webb@riversidemedical.org',
        isPrimary: true,
        source: 'site',
      ),
      JobContactData(
        name: 'Rob Stafford',
        role: 'GC Project Manager',
        phone: '312-555-9901',
        email: 'rstafford@staffordconstructors.com',
        isPrimary: false,
        source: 'job',
      ),
    ],
    crewAssignments: [
      JobCrewAssignmentData(
        userName: 'Scott Rogers',
        workDate: DateTime(2026, 4, 7),
        status: 'Assigned',
        role: 'Lead Glazier',
        notes: null,
      ),
      JobCrewAssignmentData(
        userName: 'Mike Deluca',
        workDate: DateTime(2026, 4, 7),
        status: 'Assigned',
        role: 'Glazier',
        notes: null,
      ),
    ],
    notes: [
      JobNoteData(
        authorName: 'Scott Rogers',
        createdAt: DateTime(2026, 3, 19, 14, 0),
        content:
            'Scaffold permit submitted to the city. Crew schedule stays tentative until approval comes through.',
      ),
    ],
  ),
  'job-003': JobDetailsData(
    id: 'job-003',
    jobName: 'Airport Retrofit',
    poNumber: 'PO-24680',
    status: 'Open',
    startDate: DateTime(2026, 3, 20),
    endDate: DateTime(2026, 3, 24),
    description:
        'Emergency window replacement for passenger-side glazing with infection-control style staging and fast turnarounds.',
    siteId: 'site-003',
    siteName: 'Terminal B',
    addressLine1: '100 Airport Way',
    addressLine2: 'Chicago, IL 60666',
    siteNotes:
        'Coordinate with airport operations before staging lifts. Access windows are limited during peak traffic hours.',
    contacts: const [
      JobContactData(
        name: 'Diane Torres',
        role: 'Operations Lead',
        phone: '630-555-0301',
        email: 'dtorres@terminalb.com',
        isPrimary: true,
        source: 'site',
      ),
    ],
    crewAssignments: [
      JobCrewAssignmentData(
        userName: 'Chris Paulson',
        workDate: DateTime(2026, 3, 20),
        status: 'Completed',
        role: 'Lead Glazier',
        notes: 'First window completed ahead of schedule.',
      ),
      JobCrewAssignmentData(
        userName: 'Tony Markov',
        workDate: DateTime(2026, 3, 20),
        status: 'Completed',
        role: 'Glazier',
        notes: null,
      ),
      JobCrewAssignmentData(
        userName: 'Chris Paulson',
        workDate: DateTime(2026, 3, 22),
        status: 'Confirmed',
        role: 'Lead Glazier',
        notes: null,
      ),
    ],
    notes: [
      JobNoteData(
        authorName: 'Chris Paulson',
        createdAt: DateTime(2026, 3, 20, 16, 20),
        content:
            'Window #1 replaced and sealed. Operations walk-through passed with no issues.',
      ),
    ],
  ),
  'job-004': JobDetailsData(
    id: 'job-004',
    jobName: 'University Annex',
    poNumber: 'PO-11223',
    status: 'Completed',
    startDate: DateTime(2026, 3, 3),
    endDate: DateTime(2026, 3, 7),
    description:
        'Lobby entrance glass panel replacement with re-sealing, cleanup, and final owner walkthrough.',
    siteId: 'site-004',
    siteName: 'Lincoln Park Apartments',
    addressLine1: '2200 N Lincoln Ave',
    addressLine2: 'Chicago, IL 60614',
    siteNotes:
        'Residents require 24-hour notice for unit access and freight elevator windows must be reserved.',
    contacts: const [
      JobContactData(
        name: 'Sandra Kim',
        role: 'Property Manager',
        phone: '773-555-0401',
        email: 's.kim@lpkapts.com',
        isPrimary: true,
        source: 'job',
      ),
    ],
    crewAssignments: [
      JobCrewAssignmentData(
        userName: 'Mike Deluca',
        workDate: DateTime(2026, 3, 3),
        status: 'Completed',
        role: 'Lead Glazier',
        notes: null,
      ),
      JobCrewAssignmentData(
        userName: 'Tony Markov',
        workDate: DateTime(2026, 3, 3),
        status: 'Completed',
        role: 'Glazier',
        notes: null,
      ),
    ],
    notes: [
      JobNoteData(
        authorName: 'Mike Deluca',
        createdAt: DateTime(2026, 3, 7, 15, 30),
        content:
            'Job complete. Final walk-through with Sandra Kim finished and sign-off was received.',
      ),
    ],
  ),
  'job-005': JobDetailsData(
    id: 'job-005',
    jobName: 'Civic Center Lobby',
    poNumber: 'PO-33445',
    status: 'In Progress',
    startDate: DateTime(2026, 3, 21),
    endDate: DateTime(2026, 3, 31),
    description:
        'Main lobby reglaze with phased entry sequencing so public access remains open during work hours.',
    siteId: 'site-005',
    siteName: 'Civic Center',
    addressLine1: '1 Civic Plaza',
    addressLine2: 'Chicago, IL 60602',
    siteNotes:
        'Coordinate with building security before staging in the lobby. Keep one entrance open at all times.',
    contacts: const [
      JobContactData(
        name: 'Angela Price',
        role: 'Building Manager',
        phone: '312-555-0501',
        email: 'aprice@civiccenter.gov',
        isPrimary: true,
        source: 'site',
      ),
      JobContactData(
        name: 'Nick Ford',
        role: 'GC Superintendent',
        phone: '312-555-0509',
        email: 'nford@centralbuild.com',
        isPrimary: false,
        source: 'job',
      ),
    ],
    crewAssignments: [
      JobCrewAssignmentData(
        userName: 'Scott Rogers',
        workDate: DateTime(2026, 3, 23),
        status: 'Confirmed',
        role: 'Lead Glazier',
        notes: 'Staging window is 6:00–7:00 AM only.',
      ),
      JobCrewAssignmentData(
        userName: 'Mike Deluca',
        workDate: DateTime(2026, 3, 23),
        status: 'Assigned',
        role: 'Glazier',
        notes: null,
      ),
    ],
    notes: [
      JobNoteData(
        authorName: 'Scott Rogers',
        createdAt: DateTime(2026, 3, 23, 7, 40),
        content:
            'Entry sequencing reviewed with security. South vestibule stays open while north vestibule is under active work.',
      ),
    ],
  ),
};
