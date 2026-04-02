import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/url_launcher_service.dart';
import '../../../routes/app_router.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final bool isPinned;

  const JobCard({super.key, required this.job, this.isPinned = false});

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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTight = constraints.maxWidth < 760;
                    final railWidth = isTight ? 48.0 : 54.0;
                    final locationWidth =
                        (constraints.maxWidth * (isTight ? 0.42 : 0.34))
                            .clamp(170.0, 280.0)
                            .toDouble();
                    final summary = _buildSummary(
                      context,
                      isTight: isTight,
                    );
                    final actionRail = _buildActionRail(context);
                    final addressPanel = _AddressPanel(
                      siteName: job.siteName,
                      fullAddress: _formatAddress(),
                      accentColor: statusColor,
                      onOpenMaps: () => _openLocationInMaps(context),
                      isTight: isTight,
                    );

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: railWidth, child: actionRail),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [summary],
                            ),
                          ),
                          SizedBox(width: isTight ? 12 : AppSizes.paddingLarge),
                          SizedBox(width: locationWidth, child: addressPanel),
                        ],
                      ),
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

  Future<void> _dialPrimaryContact(
    BuildContext context,
    String rawPhoneNumber,
  ) async {
    try {
      await UrlLauncherService.dialPhoneNumber(rawPhoneNumber);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open phone app.')),
        );
      }
    }
  }

  Future<void> _openLocationInMaps(BuildContext context) async {
    final query = '${job.siteName} ${_formatAddress()}';
    try {
      await UrlLauncherService.openMapLocation(query);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to open maps.')));
      }
    }
  }

  Widget _buildActionRail(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _ActionRailButton(
            tooltip: isPinned ? 'Pinned' : 'Pin',
            icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            isActive: isPinned,
            activeColor: colorScheme.primary,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: _ActionRailButton(
            tooltip: 'Add Note',
            icon: Icons.note_add_outlined,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: _ActionRailButton(
            tooltip: 'Add Photo',
            icon: Icons.add_a_photo_outlined,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  String _formatAddress() {
    final pieces = <String>[
      if (job.addressLine1 != null && job.addressLine1!.trim().isNotEmpty)
        job.addressLine1!,
      if (job.addressLine2 != null && job.addressLine2!.trim().isNotEmpty)
        job.addressLine2!,
    ];

    if (pieces.isEmpty) {
      return job.siteName;
    }

    return pieces.join(', ');
  }

  Widget _buildSummary(
    BuildContext context,
    {
    required bool isTight,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryContactName = job.primaryContactName ?? 'Not Assigned';
    final primaryContactPhone = job.primaryContactPhone;
    final canCall =
        primaryContactPhone != null && primaryContactPhone.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.jobName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: isTight ? 20 : 24,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
          maxLines: isTight ? 2 : null,
          overflow: isTight ? TextOverflow.ellipsis : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.sell_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              _formatPoNumber(job.poNumber),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Primary Contact',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              primaryContactName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (canCall)
              InkWell(
                onTap: () =>
                    _dialPrimaryContact(context, primaryContactPhone),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 2,
                  ),
                  child: Text(
                    primaryContactPhone,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
        return const Color(0xFF6B7A8A);
      case 'in progress':
        return const Color(0xFF7090A8);
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

class _ActionRailButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onPressed;

  const _ActionRailButton({
    required this.tooltip,
    required this.icon,
    this.isActive = false,
    this.activeColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedActiveColor = activeColor ?? colorScheme.primary;

    return Tooltip(
      message: tooltip,
      child: SizedBox.expand(
        child: Center(
          child: IconButton(
            tooltip: tooltip,
            onPressed: onPressed,
            icon: Icon(icon, size: 24),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              foregroundColor: isActive
                  ? resolvedActiveColor
                  : colorScheme.primary,
              backgroundColor: isActive
                  ? resolvedActiveColor.withValues(alpha: 0.16)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressPanel extends StatelessWidget {
  final String siteName;
  final String fullAddress;
  final Color accentColor;
  final VoidCallback onOpenMaps;
  final bool isTight;

  const _AddressPanel({
    required this.siteName,
    required this.fullAddress,
    required this.accentColor,
    required this.onOpenMaps,
    required this.isTight,
  });

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
        padding: EdgeInsets.all(isTight ? 12 : AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Location',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              siteName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: isTight ? 20 : null,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            InkWell(
              onTap: onOpenMaps,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  fullAddress,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: isTight ? 6 : 8),
            TextButton.icon(
              onPressed: onOpenMaps,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(
                  horizontal: isTight ? 4 : 8,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.map_outlined, size: 16),
              label: const Text('Open Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
