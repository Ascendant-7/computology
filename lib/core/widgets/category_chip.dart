import 'package:flutter/material.dart';

import 'package:computology/features/catalog/data/category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category, this.isSelected = false});

  final Category category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
      child: Text(
        category.name,
        style: TextStyle(
          fontSize: 15,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
