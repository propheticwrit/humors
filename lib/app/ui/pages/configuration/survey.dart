import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/app/ui/pages/configuration/question.dart';
import 'package:humors/app/ui/pages/configuration/survey_bloc.dart';
import 'package:humors/common/base_card.dart';
import 'package:humors/common/list/add_item.dart';
import 'package:humors/common/list/survey_item.dart';

class SurveyConfigurationPage extends StatefulWidget {
  const SurveyConfigurationPage({required this.category});

  final Category category;

  static Future<void> show(
      {required BuildContext context, required Category category}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyConfigurationPage(category: category),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _SurveyConfigurationPageState();
}

class _SurveyConfigurationPageState extends State<SurveyConfigurationPage> {
  @override
  Widget build(BuildContext context) {
    final surveyBloc = SurveyBloc(category: widget.category);

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
              title: Text('Configure Survey'),
              centerTitle: true,
            ),
            body:
                _buildContent(context, snapshot.hasData ? snapshot.data : null),
          );
        }
      },
    );
  }

  _buildContent(BuildContext context, List<Survey>? surveys) {
    return Column(
      children: _surveys(surveys),
    );
  }

  _surveys(List<Survey>? surveys) {
    List<Widget> surveyNames = <Widget>[];
    surveyNames.add(
      AddItem(
        label: 'Add Survey',
        onPressed: () {},
      ),
    );
    if (surveys != null) {
      for (Survey survey in surveys) {
        surveyNames.add(SurveyItem(
            survey: survey,
            onTap: () => QuestionConfigurationPage.show(
                context: context, survey: survey),
            onPressed: () => QuestionConfigurationPage.show(
                context: context, survey: survey),
            onLongPress: () => {},
        ),
        );
      }
    }
    return surveyNames;
  }
}
