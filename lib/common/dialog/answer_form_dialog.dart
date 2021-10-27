import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'form_dialog.dart';

Future<dynamic> showAnswerFormDialog(BuildContext context,
    {String? initialValue,
      required TextEditingController labelFieldController,
      required TextEditingController textFieldController,
      required TextEditingController styleFieldController}) =>
    showFormDialog(
      context,
      title: 'Answer',
      formFields: [
        TextFormField(
          controller: labelFieldController,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: 'Answer Label'),
          validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Label can\'t be empty',
        ),
        TextFormField(
          controller: textFieldController,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: 'Question Text'),
          validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Text can\'t be empty',
        ),
        DropdownSearch<String>(
          mode: Mode.MENU,
          selectedItem: 'Text',
            searchFieldProps: TextFieldProps(
            controller: styleFieldController,
          ),
          items: <String>[
            'Text',
            'ToggleButton',
            'Date',
            'Switch'
          ]
        ),
      ],
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
