import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:humors/app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:humors/app/models/survey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'api_path.dart';
import 'models/api_user.dart';

abstract class Connector {

  Future<List<Category>> addCategory(Category category);
  Future<List<Survey>> addSurvey(Survey survey);
  Future<List<Question>> addQuestion(Question question);


  Future<List<Category>> apiCategories();
  Future<List<Survey>> apiSurveys(Category category);
  Future<List<Question>> apiQuestions(Survey survey);

  Future<Map<Category, List<Category>>> apiBaseCategories();
}

class API {
  // body can be a string, list of strings or map
  Future<Response> _post(Uri uri, Map<String, String>? headers, Object body) async {
    return await http.post(uri, headers: headers, body: body);
  }

  Future<Response> _get(Uri uri, Map<String, String>? headers) async {
    return await http.get(uri, headers: headers);
  }
}

class MoodAuthenticator extends API {
  var client = http.Client();

  Future<APIUser> login() async {

    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if ( authToken != null ) {
      Response response = await _post(Uri.http(APIPath.url, APIPath.login()), {'Content-Type': 'application/json'}, "{\"auth_token\": \"${authToken}\"}");

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.isNotEmpty && jsonResponse.containsKey('username')) {
        String username = jsonResponse['username'];
        String email = jsonResponse['email'];
        if (jsonResponse.containsKey('tokens')) {
          String refreshToken = jsonResponse['tokens']['refresh'];
          String accessToken = jsonResponse['tokens']['access'];

          prefs.setString('accessToken', accessToken);

          print(accessToken);

          return APIUser(username, email, refreshToken, accessToken);
        } else {
          throw new HttpException('Invalid response format. No tokens found.');
        }
      } else {
        throw new HttpException('Invalid response format');
      }
    } else {
      throw new HttpException('Auth Token not available');
    }
  }
}

class MoodConnector extends API implements Connector {

  var client = http.Client();

  Future<String?> _preference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  List<Question> parseQuestions(Response response) {
    List<Question> questions = [];

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        questions.add(Question.fromJson(dict));
      }
    } on Exception {}

    return questions;
  }

  Future<List<Question>> addQuestion(Question question) async {
    String? accessToken = await _preference('accessToken');
    Response response = await _post(Uri.http(APIPath.url, APIPath.user_list('question')), {'Authorization': 'Bearer ${accessToken}'}, question.toJson());

    return parseQuestions(response);
  }

  Future<List<Question>> apiQuestions(Survey survey) async {
    String? accessToken = await _preference('accessToken');
    Response response = await _get(Uri.http(APIPath.url, APIPath.user_list('question?survey=${survey.id}')), {'Authorization': 'Bearer ${accessToken}'});

    return parseQuestions(response);
  }

  List<Survey> parseSurveys(Response response) {
    List<Survey> surveys = [];

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        surveys.add(Survey.fromJson(dict));
      }
    } on Exception {}

    return surveys;
  }

  Future<List<Survey>> addSurvey(Survey survey) async {
    String? accessToken = await _preference('accessToken');
    Response response = await _post(Uri.http(APIPath.url, APIPath.user_list('question')), {'Authorization': 'Bearer ${accessToken}'}, survey.toJson());

    return parseSurveys(response);
  }

  Future<List<Survey>> apiSurveys(Category category) async {

    String? accessToken = await _preference('accessToken');
    Response response = await _get(Uri.http(APIPath.url, APIPath.user_list('survey?category=${category.id}')), {'Authorization': 'Bearer ${accessToken}'});

    return parseSurveys(response);
  }

  List<Category> parseCategories(Response response) {
    List<Category> categories = [];

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        categories.add(Category.fromJson(dict));
      }
    } on Exception {}
    return categories;
  }

  Future<List<Category>> addCategory(Category category) async {
    String? accessToken = await _preference('accessToken');
    Response response = await _post(Uri.http(APIPath.url, APIPath.user_list('question')), {'Authorization': 'Bearer ${accessToken}'}, category.toJson());

    return parseCategories(response);
  }

  Future<List<Category>> apiCategories() async {

    String? accessToken = await _preference('accessToken');
    Response response = await _get(Uri.http(APIPath.url, APIPath.user_list('category')), {'Authorization': 'Bearer ${accessToken}'});

    return parseCategories(response);
  }

  Future<Map<Category, List<Category>>> apiBaseCategories() async {

    String? accessToken = await _preference('accessToken');
    Response response = await _get(Uri.http(APIPath.url, APIPath.user_list('category') + '/base'), {'Authorization': 'Bearer ${accessToken}'});

    Map<Category, List<Category>> baseCategories = <Category, List<Category>>{};

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        Category baseCategory = Category.fromJson(dict['parent']);
        if ( baseCategory != null ) {
          baseCategories[baseCategory] = <Category>[];

          List<dynamic> childCategories = dict['children'];

          for (var childDict in childCategories) {
            baseCategories[baseCategory]!.add(
                Category.fromJson(childDict));
          }
        }
      }
    } on Exception {
      throw new HttpException('Error parsing response');
    }
    return baseCategories;
  }

  // TODO: Token deactivates after a 15 minute time period but may want to deactivate sooner
  Future<void>? logout() {
    return null;
  }
}