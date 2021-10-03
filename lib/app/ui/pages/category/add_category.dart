import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';

import 'category_list_bloc.dart';

class AddCategoryDialog extends StatefulWidget {

  int? parentID;

  AddCategoryDialog({int? parentID});

  static Future<void> show(BuildContext context, {int? parentID}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => AddCategoryDialog(parentID: parentID),
        fullscreenDialog: true,
      ),
    );
  }
  
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';

  @override
  void initState() {
    super.initState();
    _name = '';
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if ( form != null ) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      CategoryListBloc categoryListBloc = CategoryListBloc();
      categoryListBloc.addCategory(Category(name: _name, parent: widget.parentID));
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Category Name'),
                initialValue: _name,
                validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
                onSaved: (value) => _name = value!,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text('Submit'),
          onPressed: () => _submit(),
        ),
      ],
    );
  }
}
