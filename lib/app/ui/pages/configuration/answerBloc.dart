import 'dart:io';

import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';
import 'package:rxdart/rxdart.dart';

class AnswerBloc {

  Question question;

  AnswerBloc({required this.question});

  final _apiConnector = MoodConnector();
  final _answersFetcher = PublishSubject<List<Answer>>();

  Stream<List<Answer>> get answers => _answersFetcher.stream;

  fetchAnswers() async {
    try {
      List<Answer> answers = await _apiConnector.apiAnswers(question);
      _answersFetcher.sink.add(answers);
    } on HttpException {
      _answersFetcher.sink.addError('Error parsing answers');
    }
  }

  addAnswer(Answer answer) async {
    try {
      await _apiConnector.addAnswer(answer);
    } on HttpException {
      _answersFetcher.sink.addError('Error parsing categories');
    }
  }

  editAnswer(Answer answer) async {
    try {
      await _apiConnector.editAnswer(answer);
    } on HttpException {
      _answersFetcher.sink.addError('Error parsing categories');
    }
  }

  dispose() {
    _answersFetcher.close();
  }
}