import 'package:flutter/material.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question_bloc.dart';
import 'package:humors/common/list/add_item.dart';
import 'package:humors/common/list/question_item.dart';

class QuestionConfigurationPage extends StatefulWidget {
  const QuestionConfigurationPage({required this.survey});
  final Survey survey;

  static Future<void> show({required BuildContext context, required Survey survey}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionConfigurationPage(survey: survey),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _QuestionConfigurationPageState();
}


class _QuestionConfigurationPageState extends State<QuestionConfigurationPage> {

  @override
  Widget build(BuildContext context) {
    final questionBloc = QuestionBloc(survey: widget.survey);

    return StreamBuilder<List<Question>>(
      stream: questionBloc.questions,
      builder: (context, snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting ) {
          questionBloc.fetchQuestions();
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text('Configure Questions'),
              centerTitle: true,
            ),
            body: _buildContent(context, snapshot.hasData ? snapshot.data : null),
          );
        }
      },
    );
  }

  _buildContent(BuildContext context, List<Question>? questions) {
    return Column(
      children: _questions(questions),
    );
  }

  _questions(List<Question>? questions) {
    List<Widget> questionNames = <Widget>[];
    questionNames.add(
      AddItem(
        label: 'Add Question',
        onPressed: () {},
      ),
    );
    if ( questions != null ) {
      for (Question question in questions) {
        questionNames.add(QuestionItem(question: question, onTap: () => {}, onPressed: () => {}, onLongPress: () => {}));
      }
    }
    return questionNames;
  }
}