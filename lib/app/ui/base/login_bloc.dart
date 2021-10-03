import 'dart:io';

import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';
import 'package:humors/services/models/api_user.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {

  final _apiConnector = MoodAuthenticator();
  final _userFetcher = PublishSubject<APIUser>();

  Stream<APIUser> get apiUser => _userFetcher.stream;

  login() async {
    try {
      APIUser apiuser = await _apiConnector.login();
      _userFetcher.sink.add(apiuser);
    } on HttpException {
      _userFetcher.sink.addError('Error on login attempt to MoodAPI');
    }
  }

  dispose() {
    _userFetcher.close();
  }
}