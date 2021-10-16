import 'dart:io';

import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';
import 'package:rxdart/rxdart.dart';

class SurveyBloc {

  Category category;

  SurveyBloc({required this.category});

  final _apiConnector = MoodConnector();
  final _surveysFetcher = PublishSubject<List<Survey>>();

  Stream<List<Survey>> get surveys => _surveysFetcher.stream;

  fetchSurveys() async {
    try {
      List<Survey> surveys = await _apiConnector.apiSurveys(category);
      _surveysFetcher.sink.add(surveys);
    } on HttpException {
      _surveysFetcher.sink.addError('Error parsing surveys');
    }
  }

  addSurvey(Survey survey) async {
    try {
      await _apiConnector.addSurvey(survey);
    } on HttpException {
      _surveysFetcher.sink.addError('Error parsing surveys');
    }
  }

  editSurvey(Survey survey) async {
    try {
      await _apiConnector.editSurvey(survey);
    } on HttpException {
      _surveysFetcher.sink.addError('Error parsing surveys');
    }
  }

  dispose() {
    _surveysFetcher.close();
  }
}