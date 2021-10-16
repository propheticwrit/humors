import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question_bloc.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/form/drop_down.dart';
import 'package:humors/common/form/text.dart';
import 'package:humors/common/list/add_item.dart';
import 'package:humors/common/list/configuration_item.dart';

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
  List<String> _questionTypes = ['Text', 'Toggle', 'Date', 'Switch'];

  bool _showCategoryInput = false;
  int _showSurveyInput = -1;
  int _showSurveyQuestions = -1;

  int _showSurveyQuestion = -1;

  _EditCategoryPageState({required this.category});

  @override
  void initState() {
    super.initState();
  }

  List<String> categorySurveyNames() {
    List<String> surveyNames = [];
    if (category.surveys != null && category.surveys!.length > 0) {
      for (Survey survey in category.surveys!) {
        surveyNames.add(survey.name);
      }
    }
    return surveyNames;
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
      setState(() {
        _showCategoryInput = false;
      });
    }
  }

  Future<void> _submitSurvey(Survey survey, int index) async {
    if (_validateAndSaveForm()) {
      SurveyBloc surveyBloc = SurveyBloc(category: category);
      surveyBloc.editSurvey(survey);
      setState(() {
        _showSurveyInput = -1;
        _showSurveyQuestion = -1;
        _showSurveyQuestions = -1;
      });
    }
  }

  Future<void> _submitQuestion(Survey survey, Question question, int index) async {
    if (_validateAndSaveForm()) {
      QuestionBloc questionBloc = QuestionBloc(survey: survey);
      questionBloc.editQuestion(question);
      setState(() {
        _showSurveyQuestion = -1;
      });
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
        child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    _showCategoryInput ?
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: FormTextField(
                              labelText: 'Category Name',
                              initialValue: category.name,
                              existingNames: [],
                              onSavedName: (value) =>
                              category.name = value != null ? value : '',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save),
                            iconSize: 25.0,
                            color: Colors.grey,
                            onPressed: _submitCategory,
                          )
                        ])
                    : ConfigurationItem(
                      name: category.name,
                      onTap: () {  },
                      leading: CircleAvatar(
                        radius: 15,
                        child: Text(
                          'CT',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                      trailingPressed:  () =>
                          setState(() => _showCategoryInput = true),
                    ),
                    SizedBox(height: 40.0),
                    _surveyList(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _surveyList() {
    List<Widget> surveyRows = <Widget>[];

    if (category.surveys != null) {
      for (var index = 0; index < category.surveys!.length; index++) {
        Survey survey = category.surveys![index];
        surveyRows.add(
            _showSurveyInput == index ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: FormTextField(
                  labelText: 'Survey Name',
                  initialValue: survey.name,
                  existingNames: [],
                  onSavedName: (value) =>
                  survey.name = value != null ? value : '',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                iconSize: 25.0,
                color: Colors.grey,
                onPressed: () => _submitSurvey(survey, index),
              ),
            ])
                : ConfigurationItem(
              name: survey.name,
              onTap: () => setState(() => _showSurveyQuestions = index),
              leading: CircleAvatar(
                radius: 15,
                child: Text(
                  'SV',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                backgroundColor: Colors.blue,
              ),
              trailingPressed:  () =>
                  setState(() => _showSurveyInput = index),
            ),
        );
        surveyRows.add(SizedBox(height: 10));
        if ( _showSurveyQuestions == index ) {
          surveyRows.add(_questionList(survey));
    }
      }
    }
    surveyRows.add(
        AddItem(
            label: 'Add Survey',
            onPressed: () => {}
        )
    );
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: surveyRows
    );
  }

  Widget _questionList(Survey survey) {
    List<Widget> questionRows = <Widget>[];

    if ( survey.surveyQuestions != null ) {
      for (var index = 0; index < survey.surveyQuestions!.length; index++) {
        Question question = survey.surveyQuestions![index];
        questionRows.add(
          _showSurveyInput == index ?
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: FormTextField(
                    labelText: 'Question Name',
                    initialValue: question.name,
                    existingNames: [],
                    onSavedName: (value) =>
                    question.name = value != null ? value : '',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  iconSize: 25.0,
                  color: Colors.grey,
                  onPressed: () => _submitQuestion(survey, question, index),
                ),
              ])
              : ConfigurationItem(
            name: question.name,
            onTap: () {},
            leading: CircleAvatar(
              radius: 15,
              child: Text(
                'QT',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
              backgroundColor: Colors.blue,
            ),
            trailingPressed: () =>
                setState(() => _showSurveyQuestion = index),
          ),
        );
      }
    }
    questionRows.add(
        AddItem(
            label: 'Add Question',
            onPressed: () => {}
        )
    );
    print('question rows');
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: questionRows
    );
  }
}
