import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';

class SurveyConfigurationPage extends StatefulWidget {
  const SurveyConfigurationPage({required this.category});
  final Category category;

  static Future<void> show({required BuildContext context, required Category category}) async {
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
    final apiConnector = MoodConnector();

    return StreamBuilder<List<Survey>>(
      stream: apiConnector.surveys,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          apiConnector.apiSurveys(widget.category);
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Survey>? surveys = snapshot.data;
          if (surveys != null) {
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text('Configure Survey'),
                centerTitle: true,
              ),
              body: _buildContent(context, surveys),
            );
          } else {
            return Center(child: Text('No data in categories list'));
          }
        }
      },
    );
  }

  _buildContent(BuildContext context, List<Survey> surveys) {
    return Column(
      children: _surveys(surveys),
    );
  }

  _surveys(List<Survey> surveys) {
    List<Widget> surveyNames = <Widget>[];
    for ( Survey survey in surveys ) {
      surveyNames.add(Text(survey.name));
    }
    return surveyNames;
  }
}