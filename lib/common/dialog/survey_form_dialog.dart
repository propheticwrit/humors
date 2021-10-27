import 'package:flutter/material.dart';

import 'form_dialog.dart';

Future<dynamic> showSurveyFormDialog(BuildContext context,
    {String? initialValue,
      required TextEditingController textFieldController}) =>
    showFormDialog(
      context,
      title: 'Survey',
      formFields: [
        TextFormField(
          controller: textFieldController,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: 'Survey Name'),
          validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Name can\'t be empty',
        )
      ],
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
