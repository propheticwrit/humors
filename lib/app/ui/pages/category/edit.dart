import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question_bloc.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/form/drop_down.dart';
import 'package:humors/common/form/text.dart';
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
      // Find different way to navigate to category page...go through landing with different initial page?
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
          if (survey.name == _visibleSurvey) {
            selectedSurvey = survey;
          }
        }
        if (selectedSurvey != null) {
          QuestionBloc questionBloc = QuestionBloc(survey: selectedSurvey);
          Question question = Question(
              name: _questionName!,
              survey: selectedSurvey.id!,
              text: _questionName!);
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
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormTextField(
                      labelText: 'Category Name',
                      initialValue: category.name,
                      existingNames: [],
                      onSavedName: (value) =>
                          category.name = value != null ? value : '',
                    ),
                    SizedBox(height: 20.0),
                    _surveyNames.length > 0
                        ? FormDropDown(
                            labelText: 'Select Survey',
                            initialValue: _surveyNames.first,
                            valueList: _surveyNames,
                            onChangedValue: (val) =>
                                setState(() => _visibleSurvey = val),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                  flex: 2,
                                  child: FormTextField(
                                    labelText: 'Add a survey',
                                    initialValue: '',
                                    existingNames: _surveyNames,
                                    onSavedName: (value) => _surveyName =
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
                    if (_visibleSurvey != null) _questionList(_visibleSurvey!),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                MaterialButton(
                onPressed: () => _submitCategory(),
                  child: const Text('Submit'),
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
          Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: FormTextField(
                  labelText: 'Question Name',
                  initialValue: question.name,
                  existingNames: _questionNames,
                  onSavedName: (value) =>
                      _questionName = value != null ? value : '',
                ),
              ),
            ],
          ),
        );
      }
    } else {
      questionsList.add(Row(children: [
        Expanded(
          flex: 2,
          child: FormTextField(
            labelText: 'Add a question',
            initialValue: '',
            existingNames: _questionNames,
            onSavedName: (value) => _questionName = value != null ? value : '',
          ),
        ),
        Expanded(
          flex: 1,
          child: FormDropDown(
            labelText: 'Style',
            initialValue: _questionTypes.first,
            valueList: _questionTypes,
            onChangedValue: (val) =>
                setState(() => _questionType = val),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 20.0,
          color: Colors.grey,
          onPressed: _submitQuestion,
        ),
      ]));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: questionsList,
      ),
    );
  }
}
