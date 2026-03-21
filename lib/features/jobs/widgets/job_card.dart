import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../routes/app_router.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(colorScheme);
    final leadingWash = Color.alphaBlend(
      statusColor.withValues(alpha: isDark ? 0.16 : 0.08),
      theme.cardColor,
    );
    final trailingWash = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: isDark ? 0.12 : 0.06),
      theme.cardColor,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openJob(context),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [leadingWash, theme.cardColor, trailingWash],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [statusColor, colorScheme.secondary],
                    ),
                  ),
                  child: const SizedBox(width: 8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 760;
                    final summary = _buildSummary(
                      context,
                      colorScheme,
                      statusColor,
                    );
                    final addressPanel = _AddressPanel(
                      siteId: job.siteId,
                      accentColor: statusColor,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCompact) ...[
                          summary,
                          const SizedBox(height: AppSizes.paddingMedium),
                          addressPanel,
                        ] else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: summary),
                              const SizedBox(width: AppSizes.paddingLarge),
                              SizedBox(width: 220, child: addressPanel),
                            ],
                          ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton.icon(
                              onPressed: () => _openJob(context),
                              icon: const Icon(Icons.arrow_outward),
                              label: const Text('Open Job'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.push_pin_outlined),
                              label: const Text('Pin'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.note_add_outlined),
                              label: const Text('Add Note'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add_a_photo_outlined),
                              label: const Text('Add Photo'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openJob(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.jobDetails, arguments: job.id);
  }

  Widget _buildSummary(
    BuildContext context,
    ColorScheme colorScheme,
    Color statusColor,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metaBackground = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: isDark ? 0.14 : 0.08),
      colorScheme.surfaceContainerHighest,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.jobName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetaPill(
              icon: Icons.sell_outlined,
              label: _formatPoNumber(job.poNumber),
              backgroundColor: metaBackground,
              borderColor: colorScheme.outline,
              foregroundColor: colorScheme.onSurface,
            ),
            _StatusPill(
              label: job.status,
              backgroundColor: statusColor.withValues(
                alpha: isDark ? 0.18 : 0.12,
              ),
              borderColor: statusColor.withValues(alpha: isDark ? 0.42 : 0.24),
              textColor: statusColor,
            ),
          ],
        ),
      ],
    );
  }

  Color _statusColor(ColorScheme colorScheme) {
    switch (job.status.toLowerCase()) {
      case 'open':
        return colorScheme.primary;
      case 'scheduled':
        return colorScheme.secondary;
      case 'completed':
        return colorScheme.onSurfaceVariant;
      case 'in progress':
        return const Color(0xFFD19A22);
      default:
        return colorScheme.primary;
    }
  }

  String _formatPoNumber(String poNumber) {
    final normalized = poNumber.trim();
    final prefixPattern = RegExp(r'^PO[\s\-_#:/]*', caseSensitive: false);
    final stripped = normalized.replaceFirst(prefixPattern, '');

    if (stripped.isEmpty) {
      return normalized;
    }

    return 'PO $stripped';
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _StatusPill({
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  const _MetaPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: foregroundColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressPanel extends StatelessWidget {
  final String siteId;
  final Color accentColor;

  const _AddressPanel({required this.siteId, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final panelColor = Color.alphaBlend(
      accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
      colorScheme.surfaceContainerHighest,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: accentColor),
            const SizedBox(height: 8),
            Text(
              'Address',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              siteId,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
