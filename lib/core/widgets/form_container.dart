import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const FormContainer({super.key, required this.children, this.spacing = 16.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          children
              .expand((child) => [child, SizedBox(height: spacing)])
              .toList()
            ..removeLast(),
    );
  }
}
