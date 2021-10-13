import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    required this.labelText,
    required this.initialValue,
    required this.existingNames,
    required this.onSavedName,
  });

  final String labelText;
  final String initialValue;
  final List<String> existingNames;
  final ValueChanged<String> onSavedName;

  _saveName(String? name) {
    if ( name != null ) {
      onSavedName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
          ),
          labelText: labelText),
      initialValue: initialValue,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name can\'t be empty';
        }
        if (existingNames.contains(value)) {
          return 'Name already exists';
        }
        return null;
      },
      onSaved: (value) => _saveName(value),
    );
  }
}
