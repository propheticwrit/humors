import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/list/survey_item.dart';

import 'category_list.dart';
import 'category_list_bloc.dart';

class EditCategoryPage extends StatefulWidget {
  const EditCategoryPage({required this.category});

  final Category category;

  static Future<void> show(
      {required BuildContext context, required Category category}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(category: category),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  String _categoryName = '';

  @override
  void initState() {
    super.initState();
    _categoryName = widget.category.name;
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
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
      categoryListBloc
          .editCategory(Category(id: widget.category.id, name: _categoryName, parent: widget.category.parent, created: widget.category.created));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SurveyBloc surveyBloc = SurveyBloc(category: widget.category);
    return StreamBuilder<List<Survey>>(
        stream: surveyBloc.surveys,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            surveyBloc.fetchSurveys();
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text('Edit Category $_categoryName'),
                centerTitle: true,
              ),
              body: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Category Name'),
                              initialValue: _categoryName,
                              validator: (value) => value != null && value.isNotEmpty
                                  ? null
                                  : 'Name can\'t be empty',
                              onSaved: (value) => _categoryName = value != null ? value : '',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        FlatButton(
                          child: Text('Submit'),
                          onPressed: () => _submit(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );

  }

  List<Widget> surveyList(List<Survey> surveys) {
    List<Widget> surveyList = [];
    for ( Survey survey in surveys ) {
      surveyList.add(SurveyItem(
          survey: survey,
          onTap: () => {}));
    }
    return surveyList;
  }
}
