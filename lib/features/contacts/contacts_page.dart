import 'package:flutter/material.dart';

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  static const List<_OrgMember> _members = [
    _OrgMember(name: 'Morgan Shaw', role: 'Operations Director', level: 0),
    _OrgMember(name: 'Avery Brooks', role: 'Regional Manager', level: 1),
    _OrgMember(name: 'Jamie Patel', role: 'Field Supervisor', level: 2),
    _OrgMember(name: 'Taylor Reed', role: 'Dispatcher', level: 2),
    _OrgMember(name: 'Riley Kim', role: 'Account Coordinator', level: 1),
    _OrgMember(name: 'Jordan Diaz', role: 'Customer Success', level: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(Icons.account_tree, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Organization', style: theme.textTheme.headlineSmall),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Contact roster view of your team and reporting structure.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Org chart preview', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                ..._members.map(
                  (member) => Padding(
                    padding: EdgeInsets.only(
                      left: 12.0 * member.level,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          member.level == 0
                              ? Icons.star_outline
                              : Icons.subdirectory_arrow_right,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name,
                                  style: theme.textTheme.titleMedium),
                              Text(member.role),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrgMember {
  const _OrgMember({
    required this.name,
    required this.role,
    required this.level,
  });

  final String name;
  final String role;
  final int level;
}
