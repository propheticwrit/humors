import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question_bloc.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/list/add_item.dart';
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
  State<StatefulWidget> createState() =>
      _EditCategoryPageState(category: category);
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  Category category;

  String? _visibleSurvey;
  String? _surveyName;
  String? _questionName;
  String? _questionType;

  List<String> _surveyNames = [];
  List<String> _questionNames = [];
  List<String> _questionTypes = ['Text', 'Toggle', 'Date', 'Switch'];

  _EditCategoryPageState({required this.category});

  @override
  void initState() {
    super.initState();

    if (category.surveys != null && category.surveys!.length > 0) {
      for (Survey survey in category.surveys!) {
        _surveyNames.add(survey.name);
      }
    }
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

  Future<void> _submitCategory() async {
    if (_validateAndSaveForm()) {
      CategoryListBloc categoryListBloc = CategoryListBloc();
      categoryListBloc.editCategory(Category(
          id: category.id,
          name: category.name,
          parent: category.parent,
          created: category.created));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
  }

  Future<void> _submitQuestion() async {
    if (_validateAndSaveForm()) {
      if (_questionName != null) {
        Survey? selectedSurvey;
        for (Survey survey in category.surveys!) {
          if ( survey.name == _visibleSurvey ) {
            selectedSurvey = survey;
          }
        }
        if ( selectedSurvey != null ) {
          QuestionBloc questionBloc = QuestionBloc(survey: selectedSurvey);
          Question question = Question(
              name: _questionName!, survey: selectedSurvey.id!, text: _questionName!);
          questionBloc.addQuestion(question);
          setState(() {
            _questionNames.add(_questionName!);
          });
        }
      }
    }
  }

  Future<void> _submitSurvey() async {
    if (_validateAndSaveForm()) {
      if (_surveyName != null) {
        SurveyBloc surveyBloc = SurveyBloc(category: category);
        Survey survey = Survey(name: _surveyName!, category: category.id!);
        surveyBloc.addSurvey(survey);
        setState(() {
          _surveyNames.add(_surveyName!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Edit Category ${category.name}'),
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
                      initialValue: category.name,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Name can\'t be empty',
                      onSaved: (value) =>
                          category.name = value != null ? value : '',
                    ),
                    _surveyNames.length > 0
                        ? DropdownButtonFormField<String>(
                            value: _visibleSurvey,
                            items: _surveyNames.map<DropdownMenuItem<String>>(
                              (String val) {
                                return DropdownMenuItem(
                                  child: Text(val),
                                  value: val,
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(() {
                                _visibleSurvey = val;
                              });
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Flexible(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Add a survey'),
                                    initialValue: '',
                                    validator: (value) =>
                                        value != null && value.isNotEmpty && ! _surveyNames.contains(value)
                                            ? null
                                            : 'Name can\'t be empty',
                                    onSaved: (value) => _surveyName =
                                        value != null ? value : '',
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  iconSize: 20.0,
                                  color: Colors.grey,
                                  onPressed: _submitSurvey,
                                )
                              ]),
                    if (_visibleSurvey != null)
                      _questionList(_visibleSurvey!),
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
                  onPressed: () => _submitCategory(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionList(String survey_name) {
    List<Question>? questions;

    if (category.surveys != null) {
      for (Survey survey in category.surveys!) {
        if (survey.name == survey_name) {
          questions = survey.surveyQuestions;
        }
      }
    }

    List<Widget> questionsList = [];
    if (questions != null && questions.length > 0) {
      for (Question question in questions) {
        questionsList.add(
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
            leading: Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Question Name'),
                initialValue: question.name,
                validator: (value) => value != null && value.isNotEmpty && ! _questionNames.contains(value)
                    ? null
                    : 'Name can\'t be empty',
                onSaved: (value) => question.name = value != null ? value : '',
              ),
            ),
            title: Text(
              question.name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right),
              iconSize: 20.0,
              color: Colors.grey,
              onPressed: () {},
            ),
            onTap: () => {},
          ),
        );
      }
    } else {
      questionsList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Add a question'),
                initialValue: '',
                validator: (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Name can\'t be empty',
                onSaved: (value) => _questionName =
                value != null ? value : '',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _questionType,
              items: _questionTypes.map<DropdownMenuItem<String>>(
                    (String val) {
                  return DropdownMenuItem(
                    child: Text(val),
                    value: val,
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(() {
                  _questionType = val;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 20.0,
              color: Colors.grey,
              onPressed: _submitQuestion,
            )
          ]));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: questionsList,
      ),
    );
  }

  List<Widget> _surveyList(List<Survey>? surveys) {
    List<Widget> surveyList = [];
    if (surveys != null) {
      for (Survey survey in surveys) {
        surveyList.add(SurveyItem(survey: survey, onTap: () => {}));
      }
    }
    return surveyList;
  }
}
