import 'package:flutter/material.dart';

import 'package:computology/features/pc_builder/logic/compatibility_service.dart';

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
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
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
              _StatusHeader(result: result),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  children: [
                    if (result.errors.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Errors',
                        count: result.errors.length,
                        color: colorScheme.error,
                      ),
                      ...result.errors.map((issue) => _IssueCard(issue: issue)),
                      const SizedBox(height: 24),
                    ],
                    if (result.warnings.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Warnings',
                        count: result.warnings.length,
                        color: Colors.orange,
                      ),
                      ...result.warnings.map((issue) => _IssueCard(issue: issue)),
                      const SizedBox(height: 24),
                    ],
                    if (result.passed.isNotEmpty) ...[
                      _SectionTitle(
                        label: 'Passed Checks',
                        count: result.passed.length,
                        color: Colors.green,
                      ),
                      ...result.passed.map((issue) => _IssueCard(issue: issue)),
                      const SizedBox(height: 24),
                    ],
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

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.result});

  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool compatible = result.isCompatible;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: compatible
                    ? Colors.green.withValues(alpha: 0.15)
                    : theme.colorScheme.error.withValues(alpha: 0.15),
              ),
              child: Icon(
                compatible ? Icons.check_circle : Icons.error,
                color: compatible ? Colors.green : theme.colorScheme.error,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    compatible ? 'Build is Compatible' : 'Incompatible Build',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: compatible ? Colors.green : theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    compatible
                        ? (result.warnings.isNotEmpty
                            ? 'All critical checks passed, but ${result.warnings.length} warning(s) found.'
                            : 'All checks passed. You are ready to build!')
                        : '${result.errors.length} critical error(s) found. You must fix them before proceeding.',
                    style: theme.textTheme.bodyMedium?.copyWith(
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.count, required this.color});

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: iconColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: iconColor, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            issue.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
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
    );
  }
}
