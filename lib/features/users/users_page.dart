import 'package:flutter/material.dart';

import 'controllers/profiles_controller.dart';
import 'models/user_profile.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfilesControllerScope.of(context);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError && controller.profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.errorMessage ?? 'Failed to load profiles.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: controller.fetchProfiles,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        _ProfileList(profiles: controller.profiles),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () =>
                _showAddProfileDialog(context, controller: controller),
            tooltip: 'Add user',
            child: const Icon(Icons.person_add),
          ),
        ),
      ],
    );
  }

  void _showAddProfileDialog(
    BuildContext context, {
    required ProfilesController controller,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => ProfilesControllerScope(
        controller: controller,
        child: const _ProfileFormDialog(),
      ),
    );
  }
}

class _ProfileList extends StatelessWidget {
  const _ProfileList({required this.profiles});

  final List<UserProfile> profiles;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Center(
        child: Text('No user profiles found.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _ProfileTile(profile: profiles[index]);
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ProfilesControllerScope.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: profile.isActive
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        child: Text(
          _initials(profile.fullName),
          style: theme.textTheme.labelMedium?.copyWith(
            color: profile.isActive
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        profile.fullName,
        style: profile.isActive
            ? null
            : theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
      subtitle: Text(
        profile.phone != null && profile.phone!.isNotEmpty
            ? '${profile.email} · ${profile.phone}'
            : profile.email,
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!profile.isActive)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                label: const Text('Inactive'),
                labelStyle: theme.textTheme.labelSmall,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => _showEditDialog(context, controller: controller),
          ),
          IconButton(
            icon: Icon(
              profile.isActive
                  ? Icons.person_off_outlined
                  : Icons.person_outlined,
            ),
            tooltip: profile.isActive ? 'Deactivate' : 'Reactivate',
            onPressed: () => _toggleActive(context, controller: controller),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required ProfilesController controller,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => ProfilesControllerScope(
        controller: controller,
        child: _ProfileFormDialog(profile: profile),
      ),
    );
  }

  Future<void> _toggleActive(
    BuildContext context, {
    required ProfilesController controller,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final newActive = !profile.isActive;
    final action = newActive ? 'reactivated' : 'deactivated';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(newActive ? 'Reactivate User?' : 'Deactivate User?'),
        content: Text(
          newActive
              ? 'Allow ${profile.fullName} to access the app again?'
              : 'Prevent ${profile.fullName} from accessing the app? '
                  'This can be reversed later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(newActive ? 'Reactivate' : 'Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await controller.setActive(
      profile.id,
      isActive: newActive,
    );

    if (!context.mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '${profile.fullName} has been $action.'
              : controller.errorMessage ?? 'Failed to update status.',
        ),
        backgroundColor: success
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _ProfileFormDialog extends StatefulWidget {
  const _ProfileFormDialog({this.profile});

  final UserProfile? profile;

  @override
  State<_ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends State<_ProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _emailController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;

  bool get _isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.profile?.id ?? '');
    _emailController = TextEditingController(
      text: widget.profile?.email ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.profile?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.profile?.phone ?? '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProfilesControllerScope.of(context);

    return AlertDialog(
      title: Text(_isEditing ? 'Edit User' : 'Add User'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isEditing) ...[
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'User UUID',
                    helperText: 'Must match the Supabase auth user ID',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'User UUID is required';
                    }
                    final uuidRegex = RegExp(
                      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
                      caseSensitive: false,
                    );
                    if (!uuidRegex.hasMatch(value.trim())) {
                      return 'Enter a valid UUID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  final emailRegex = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone (optional)'),
                keyboardType: TextInputType.phone,
              ),
              if (controller.hasError) ...[
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: controller.isSaving
              ? null
              : () => _submit(context, controller: controller),
          child: controller.isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _submit(
    BuildContext context, {
    required ProfilesController controller,
  }) async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final profile = UserProfile(
      id: _isEditing
          ? widget.profile!.id
          : _idController.text.trim(),
      email: _emailController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phone: phone.isEmpty ? null : phone,
      isActive: widget.profile?.isActive ?? true,
      avatarUrl: widget.profile?.avatarUrl,
    );

    final success = await controller.saveProfile(profile);
    if (success && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
