import 'package:flutter/material.dart';

import 'package:computology/features/pc_builder/logic/compatibility_service.dart';

/// Bottom sheet that displays the results of a PC build compatibility check.
///
/// Shows a status header, then lists all errors, warnings, and passed checks
/// with color-coded icons.
class CompatibilityResultSheet extends StatelessWidget {
  const CompatibilityResultSheet({
    super.key,
    required this.result,
  });

  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Status header
              _StatusHeader(result: result),

              const Divider(height: 1),

              // Check list
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    if (result.errors.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Errors (${result.errors.length})',
                        color: colorScheme.error,
                      ),
                      ...result.errors.map(
                        (issue) => _IssueCard(issue: issue),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (result.warnings.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Warnings (${result.warnings.length})',
                        color: Colors.orange,
                      ),
                      ...result.warnings.map(
                        (issue) => _IssueCard(issue: issue),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (result.passed.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Passed (${result.passed.length})',
                        color: Colors.green,
                      ),
                      ...result.passed.map(
                        (issue) => _IssueCard(issue: issue),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Private helper widgets
// -----------------------------------------------------------------------------

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.result});

  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool compatible = result.isCompatible;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: compatible
                  ? Colors.green.withValues(alpha: 0.15)
                  : theme.colorScheme.error.withValues(alpha: 0.15),
            ),
            child: Icon(
              compatible ? Icons.check_circle : Icons.cancel,
              color: compatible ? Colors.green : theme.colorScheme.error,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compatible ? 'Build Compatible' : 'Incompatible Build',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: compatible
                        ? Colors.green
                        : theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  compatible
                      ? 'All critical checks passed. '
                        '${result.warnings.isNotEmpty ? '${result.warnings.length} warning(s) found.' : 'Ready to build!'}'
                      : '${result.errors.length} error(s) found. '
                        'Fix them before building.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final CompatibilityIssue issue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late final IconData icon;
    late final Color iconColor;

    switch (issue.level) {
      case CompatibilityLevel.error:
        icon = Icons.error;
        iconColor = theme.colorScheme.error;
      case CompatibilityLevel.warning:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.orange;
      case CompatibilityLevel.passed:
        icon = Icons.check_circle;
        iconColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    issue.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
