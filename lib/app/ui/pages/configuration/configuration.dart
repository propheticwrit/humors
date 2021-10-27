import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question_bloc.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/dialog/answer_form_dialog.dart';
import 'package:humors/common/dialog/question_form_dialog.dart';
import 'package:humors/common/dialog/survey_form_dialog.dart';
import 'package:humors/common/list/add_item.dart';
import 'package:humors/common/list/survey_item.dart';
import 'package:humors/common/survey_card.dart';
import 'package:uuid/uuid.dart';

import 'answerBloc.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({required this.category});

  final Category category;

  static Future<void> show(
      {required BuildContext context, required Category category}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigurationPage(category: category),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() =>
      _ConfigurationPageState(category: category);
}

class _ConfigurationPageState extends State<ConfigurationPage> {

  Category category;

  _ConfigurationPageState({required this.category});

  String? _showSurvey;

  bool _validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    print('validate form');
    if (form != null) {
      if (form.validate()) {
        form.save();
        print('saved form');
        return true;
      }
    }
    return false;
  }

  Future<void> _addSurvey() async {
    TextEditingController textFieldController = TextEditingController();

    var result = await showSurveyFormDialog(context, textFieldController: textFieldController);

    if (result) {
      var uuid = Uuid();
      Survey survey = Survey(id: uuid.v4(), name:textFieldController.text, category: category.id);
      SurveyBloc surveyBloc = SurveyBloc(category: category);
      surveyBloc.addSurvey(survey);

      if ( category.surveys != null ) {
        category.surveys!.add(survey);
      } else {
        category.surveys = [survey];
      }
      setState(() => {});
    }
  }

  Future<void> _addQuestion(BuildContext context, Survey survey) async {

    TextEditingController textFieldController = TextEditingController();
    TextEditingController nameFieldController = TextEditingController();

    var result = await showQuestionFormDialog(context, nameFieldController: nameFieldController, textFieldController: textFieldController);

    if (result) {
      var uuid = Uuid();
      Question question = Question(id: uuid.v4(), name: nameFieldController.text, text: textFieldController.text, survey: survey.id);
      QuestionBloc questionBloc = QuestionBloc(survey: survey);
      questionBloc.addQuestion(question);

      if ( category.surveys != null ) {
        for (Survey catSurvey in category.surveys!) {
          if ( catSurvey.id == survey.id ) {
            if (catSurvey.surveyQuestions != null) {
              catSurvey.surveyQuestions!.add(question);
            } else {
              catSurvey.surveyQuestions = [question];
            }
          }
        }
      }
      setState(() => {});
    }
  }

  Future<void> _addAnswer(BuildContext context, Question question) async {

    TextEditingController textFieldController = TextEditingController();
    TextEditingController labelFieldController = TextEditingController();
    TextEditingController styleFieldController = TextEditingController();

    var result = await showAnswerFormDialog(context, labelFieldController: labelFieldController, textFieldController: textFieldController, styleFieldController: styleFieldController);

    int sequence = 0;
    if ( question.answers != null ) {
      for ( Answer answer in question.answers! ) {
        if ( answer.sequence >= sequence ) {
          sequence = answer.sequence + 1;
        }
      }
    }

    if (result) {
      var uuid = Uuid();
      Answer answer = Answer(sequence: sequence, question: question.id, id: uuid.v4(), style: styleFieldController.text, label: labelFieldController.text, text: textFieldController.text);
      AnswerBloc answerBloc = AnswerBloc(question: question);
      answerBloc.addAnswer(answer);

      if ( category.surveys != null ) {
        for (Survey catSurvey in category.surveys!) {
          if ( catSurvey.surveyQuestions != null ) {
            for ( Question catQuestion in catSurvey.surveyQuestions! ) {
              if ( catQuestion.id == question.id ) {
                if ( catQuestion.answers != null ) {
                  catQuestion.answers!.add(answer);
                } else {
                  catQuestion.answers = [answer];
                }
              }
            }
          }
        }
      }
      setState(() => {});
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
      body: Column(
        children: <Widget>[
          AddItem(
            label: 'Add Survey',
            onPressed: _addSurvey,
          ),
          if (category.surveys != null)
            Expanded(
              child: ListView.builder(
                  itemCount: category.surveys!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Survey survey = category.surveys![index];
                    if (survey.id == _showSurvey) {
                      return _surveyCard(context, survey);
                    } else {
                      return _surveyItem(survey);
                    }
                  }),
            ),
        ],
      ),
    );
  }

  Widget _surveyItem(Survey survey) {
    return SurveyItem(
      survey: survey,
      onTap: () => setState(() => _showSurvey = survey.id),
      onPressed: () => setState(() => _showSurvey = survey.id),
      onLongPress: () => setState(() => _showSurvey = survey.id),
    );
  }

  Widget _surveyCard(BuildContext context, Survey survey) {
    return SurveyCard(
      survey: survey,
      questionList: _questionList(context, survey),
      onPressed: () => setState(() => _showSurvey = null),
    );
  }

  List<Widget> _questionList(BuildContext context, Survey survey) {
    List<Widget> questionsList = [];
    if (survey.surveyQuestions != null) {
      for (Question question in survey.surveyQuestions!) {
        questionsList.add(
          Divider(
            color: Colors.grey,
          ),
        );
        questionsList.add(Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: ListTile(
            title: Text(
              question.name,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
        ));
        questionsList.add(
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: FlatButton(
                color: Colors.transparent,
                splashColor: Colors.black26,
                onPressed: () => _addAnswer(context, question),
                child: Text(
                  '+ Add/Edit',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            )
        );
      }
    }
    questionsList.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: AddItem(
        label: 'Add Question',
        onPressed: () => _addQuestion(context, survey),
      ),
    ));
    return questionsList;
  }
}
