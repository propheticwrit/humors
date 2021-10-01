import 'dart:async';
import 'dart:io';

import 'package:humors/app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:humors/app/models/survey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'api_path.dart';
import 'auth.dart';
import 'models/api_user.dart';

abstract class Connector {
  Future<APIUser> login();
  Future<List<Category>> apiCategories();
  Future<List<Survey>> apiSurveys(Category category);
  Future<Map<Category, List<Category>>> apiBaseCategories();
}

class MoodConnector implements Connector {

  var client = http.Client();

  Future<APIUser> login() async {

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? null;

    String username = '';
    String email = '';
    String refreshToken = '';
    String accessToken = '';
    if ( authToken != null ) {
      var uri = Uri.http(APIPath.url, APIPath.login());
      String body = "{\"auth_token\": \"${authToken}\"}";
      final response = await http.post(
          uri, headers: {'Content-Type': 'application/json'}, body: body);

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('json response: ${jsonResponse}');

      if (jsonResponse.isNotEmpty && jsonResponse.containsKey('username')) {
        username = jsonResponse['username'];
        email = jsonResponse['email'];
        if (jsonResponse.containsKey('tokens')) {
          refreshToken = jsonResponse['tokens']['refresh'];
          accessToken = jsonResponse['tokens']['access'];
        }
        // return APIUser(username, email, refreshToken, accessToken);

        prefs.setString('accessToken', accessToken);

        return APIUser(username, email, refreshToken, accessToken);
      } else {
        throw new HttpException('Invalid response format');
      }
    } else {
      throw new HttpException('Auth Token not available');
    }
  }

  Future<List<Survey>> apiSurveys(Category category) async {

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? null;

    var uri = Uri.http(APIPath.url, APIPath.user_list('survey?category=${category.id}'));

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });

    List<Survey> surveys = [];
    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        surveys.add(Survey.fromJson(dict));
      }
    } catch (Exception) {
      throw new HttpException("Could not parse the service response");
    }
    return surveys;
  }

  Future<List<Category>> apiCategories() async {

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? null;

    List<Category> categories = [];

    var uri = Uri.http(APIPath.url, APIPath.user_list('category'));

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        categories.add(Category.fromJson(dict));
      }
    } catch (Exception) {
      throw new HttpException('Could not parse categories');
    }
    return categories;
  }

  Future<Map<Category, List<Category>>> apiBaseCategories() async {

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? null;

    Map<Category, List<Category>> baseCategories = <Category, List<Category>>{};

    var uri = Uri.http(APIPath.url, APIPath.user_list('category') + '/base');

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });

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
    } catch (Exception) {
      throw new HttpException('Error parsing response');
    }
    return baseCategories;
  }

  // TODO: Token deactivates after a 15 minute time period but may want to deactivate sooner
  Future<void>? logout() {
    return null;
  }
}