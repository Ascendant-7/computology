import 'package:flutter/material.dart';

import 'app_text_field.dart';

class DynamicFormBuilder extends StatelessWidget {
  final List<Map<String, dynamic>> schema;
  final Map<String, TextEditingController> controllers;

  const DynamicFormBuilder({
    super.key,
    required this.schema,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: schema
          .map(
            (field) => AppTextField(
              controller: controllers[field['key']]!,
              label: field['label'],
            ),
          )
          .toList(),
    );
  }
}
