import 'dart:io';

import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(
    BuildContext context, {
      required String title,
      required String content,
      required String cancelActionText,
      required String defaultActionText,
    }) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          FlatButton(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        FlatButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}