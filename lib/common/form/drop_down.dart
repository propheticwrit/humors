import 'package:flutter/material.dart';

class FormDropDown extends StatelessWidget {
  const FormDropDown({
    required this.labelText,
    required this.initialValue,
    required this.valueList,
    required this.onChangedValue,
  });

  final String labelText;
  final String initialValue;
  final List<String> valueList;
  final ValueChanged<String> onChangedValue;

  _setName(String? name) {
    if ( name != null ) {
      onChangedValue(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
          ),
          labelText: labelText),
      value: initialValue,
      items: valueList.map<DropdownMenuItem<String>>(
            (String val) {
          return DropdownMenuItem(
            child: Text(val),
            value: val,
          );
        },
      ).toList(),
      onChanged: (val) => _setName(val),
    );
  }
}
