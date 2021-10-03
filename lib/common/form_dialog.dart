import 'package:flutter/material.dart';

Future<dynamic> showFormDialog(
  BuildContext context, {
  required GlobalKey<FormState> formKey,
  required String title,
  required List<String> labels,
  required String cancelActionText,
  required String defaultActionText,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _formFields(labels),
          ),
        ),
      ),
      actions: <Widget>[
        if (cancelActionText != null)
          FlatButton(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        FlatButton(
          child: Text(defaultActionText),
          onPressed: () => _submit(context),
        ),
      ],
    ),
  );
}

_submit(BuildContext context) {
  Navigator.of(context).pop(true);
}

_formFields(List<String> labels) {
  List<Widget> fields = [];

  for (String label in labels) {
    fields.add(TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
    ));
  }
  return fields;
}
