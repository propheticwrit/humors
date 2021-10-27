import 'package:flutter/material.dart';

import 'form_dialog.dart';

Future<dynamic> showQuestionFormDialog(BuildContext context,
        {String? initialValue,
          required TextEditingController nameFieldController,
          required TextEditingController textFieldController}) =>
    showFormDialog(
      context,
      title: 'Question',
      formFields: [
        TextFormField(
          controller: nameFieldController,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: 'Question Name'),
          validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Name can\'t be empty',
        ),
        TextFormField(
          controller: textFieldController,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: 'Question Text'),
          validator: (value) =>
              value != null && value.isNotEmpty ? null : 'Name can\'t be empty',
        )
      ],
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
