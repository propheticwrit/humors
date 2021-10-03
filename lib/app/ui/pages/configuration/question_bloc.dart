import 'dart:io';

import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';
import 'package:rxdart/rxdart.dart';

class QuestionBloc {

  Survey survey;

  QuestionBloc({required this.survey});

  final _apiConnector = MoodConnector();
  final _questionsFetcher = PublishSubject<List<Question>>();

  Stream<List<Question>> get questions => _questionsFetcher.stream;

  fetchQuestions() async {
    try {
      List<Question> questions = await _apiConnector.apiQuestions(survey);
      _questionsFetcher.sink.add(questions);
    } on HttpException {
      _questionsFetcher.sink.addError('Error parsing questions');
    }
  }

  addQuestion(Question question) async {
    try {
      List<Question> questions = await _apiConnector.addQuestion(question);
      _questionsFetcher.sink.add(questions);
    } on HttpException {
      _questionsFetcher.sink.addError('Error parsing categories');
    }
  }

  dispose() {
    _questionsFetcher.close();
  }
}