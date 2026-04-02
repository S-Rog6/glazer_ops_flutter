import 'package:flutter/material.dart';

import '../../core/config/app_environment.dart';
import '../../core/supabase/supabase_bootstrap.dart';
import '../../core/theme/theme_controller.dart';
import '../jobs/controllers/jobs_controller.dart';
import '../jobs/data/jobs_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isTestingConnection = false;
  bool _isRefreshingData = false;
  RepositoryConnectionStatus? _lastConnectionStatus;

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeControllerScope.of(context);
    final jobsController = JobsControllerScope.of(context);
    final repository = JobsRepositoryScope.of(context);
    final bootstrapState = SupabaseBootstrap.state;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Theme'),
                subtitle: Text(
                  themeController.isDarkMode ? 'Dark mode' : 'Light mode',
                ),
              ),
              SwitchListTile.adaptive(
                title: const Text('Use dark theme'),
                value: themeController.isDarkMode,
                onChanged: (isDarkMode) {
                  themeController.updateThemeMode(
                    isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data & Connection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Data source',
                  value: jobsController.dataSourceLabel,
                ),
                _InfoRow(
                  label: 'Supabase configured',
                  value: AppEnvironment.isSupabaseConfigured ? 'Yes' : 'No',
                ),
                _InfoRow(
                  label: 'Project host',
                  value: AppEnvironment.supabaseHost,
                ),
                _InfoRow(
                  label: 'Active user ID',
                  value: AppEnvironment.maskProfileId(
                    jobsController.activeUserId,
                  ),
                ),
                _InfoRow(
                  label: 'Bootstrap status',
                  value: bootstrapState.isReady
                      ? 'Ready'
                      : (bootstrapState.isConfigured
                            ? 'Initialization failed'
                            : 'Not configured'),
                ),
                _InfoRow(
                  label: 'Bootstrap details',
                  value: bootstrapState.message,
                ),
                _InfoRow(
                  label: 'Last successful refresh',
                  value: _formatTimestamp(
                    jobsController.lastSuccessfulRefreshAt,
                  ),
                ),
                _InfoRow(
                  label: 'Last connection test',
                  value: _lastConnectionStatus == null
                      ? 'Not tested yet'
                      : '${_lastConnectionStatus!.title} · ${_formatTimestamp(_lastConnectionStatus!.checkedAt)}',
                ),
                if (_lastConnectionStatus != null) ...[
                  const SizedBox(height: 8),
                  _ConnectionResultBanner(status: _lastConnectionStatus!),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: _isTestingConnection
                          ? null
                          : () => _testConnection(
                              context,
                              repository: repository,
                              jobsController: jobsController,
                            ),
                      icon: _isTestingConnection
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_done_outlined),
                      label: Text(
                        _isTestingConnection
                            ? 'Testing...'
                            : 'Test Supabase Connection',
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isRefreshingData || jobsController.isLoading
                          ? null
                          : () => _refreshData(
                              context,
                              jobsController: jobsController,
                            ),
                      icon: _isRefreshingData || jobsController.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(
                        _isRefreshingData || jobsController.isLoading
                            ? 'Refreshing...'
                            : 'Refresh Data',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Connection test verifies that the configured data source can execute the same read path this app depends on. Refresh data reloads the current jobs snapshot through the app repository/controller path.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Column(
            children: [
              ListTile(title: Text('Notifications')),
              ListTile(title: Text('About')),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _testConnection(
    BuildContext context, {
    required JobsRepository repository,
    required JobsController jobsController,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    setState(() {
      _isTestingConnection = true;
    });

    late final RepositoryConnectionStatus status;

    try {
      status = await repository.testConnection(
        activeUserId: jobsController.activeUserId,
      );
    } catch (error) {
      status = RepositoryConnectionStatus(
        isSuccess: false,
        isConfigured: AppEnvironment.isSupabaseConfigured,
        isLiveDataSource: repository.isLiveDataSource,
        title: 'Connection test failed',
        message:
            'Unexpected error while testing the data source. Error: $error',
        checkedAt: DateTime.now(),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isTestingConnection = false;
      _lastConnectionStatus = status;
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(status.isSuccess ? status.title : status.message),
        backgroundColor: status.isSuccess
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
      ),
    );
  }

  Future<void> _refreshData(
    BuildContext context, {
    required JobsController jobsController,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    setState(() {
      _isRefreshingData = true;
    });

    bool success;
    try {
      success = await jobsController.fetchJobs();
    } catch (error) {
      success = false;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isRefreshingData = false;
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Data refreshed successfully.'
              : (jobsController.errorMessage ?? 'Failed to refresh data.'),
        ),
        backgroundColor: success
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ConnectionResultBanner extends StatelessWidget {
  const _ConnectionResultBanner({required this.status});

  final RepositoryConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = status.isSuccess
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;
    final background = status.isSuccess
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status.message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

String _formatTimestamp(DateTime? value) {
  if (value == null) {
    return 'Not available';
  }

  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour == 0
      ? 12
      : (value.hour > 12 ? value.hour - 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final meridiem = value.hour >= 12 ? 'PM' : 'AM';
  return '${value.year}-$month-$day $hour:$minute $meridiem';
}
