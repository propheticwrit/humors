import 'package:flutter/material.dart';

Future<dynamic> showFormDialog(BuildContext context,
    {required String title,
    required List<Widget> formFields,
    required VoidCallback onPressed}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: formFields,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text('Submit'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
