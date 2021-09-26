import 'dart:async';

import 'package:humors/app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'api_path.dart';
import 'auth.dart';
import 'models/api_user.dart';

abstract class Connector {

  Stream<APIUser> get apiUser;
  Stream<List<Category>> get categories;
  Stream<Map<Category, List<Category>>> get baseCategories;

  Future<void> login();
  Future<void> apiCategories();
  Future<void> apiBaseCategories();
}

class MoodConnector implements Connector {

  var client = http.Client();

  final _userFetcher = PublishSubject<APIUser>();
  final _categoriesFetcher = PublishSubject<List<Category>>();
  final _baseCategoriesFetcher = PublishSubject<Map<Category, List<Category>>>();

  Stream<APIUser> get apiUser => _userFetcher.stream;

  Stream<List<Category>> get categories => _categoriesFetcher.stream;
  Stream<Map<Category, List<Category>>> get baseCategories => _baseCategoriesFetcher.stream;

  dispose() {
    _userFetcher.close();
    _categoriesFetcher.close();
    _baseCategoriesFetcher.close();
  }

  // APIUser? _apiUser;

  // @override
  // APIUser? get apiUser => _apiUser;

  // Stream<APIUser> login() => Stream.fromFuture(authenticate());

  Future<void> login() async {

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

        _userFetcher.sink.add(APIUser(username, email, refreshToken, accessToken));
      } else {
        _userFetcher.sink.addError(new FormatException('Invalid response format'));
      }
    } else {
      _userFetcher.sink.addError(new http.ClientException('Auth Token not available'));
    }
  }

  Future<void> apiCategories() async {

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
      _categoriesFetcher.sink.addError('Error parsing response');
    }
    _categoriesFetcher.sink.add(categories);
  }

  //[
  //     {
  //         "cat1": {
  //             "id": 1,
  //             "name": "cat1",
  //             "created": "2021-09-10T20:28:50.344981Z",
  //             "modified": "2021-09-10T20:28:50.344981Z",
  //             "parent": null,
  //             "user": [
  //                 2
  //             ]
  //         },
  //         "children": [
  //             {
  //                 "id": 7,
  //                 "name": "cat1child1",
  //                 "created": "2021-09-25T18:05:45.375233Z",
  //                 "modified": "2021-09-25T18:05:45.375233Z",
  //                 "parent": 1,
  //                 "user": [
  //                     2
  //                 ]
  //             }
  //         ]
  Future<void> apiBaseCategories() async {

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
      _baseCategoriesFetcher.sink.addError('Error parsing response');
    }
    _baseCategoriesFetcher.sink.add(baseCategories);
  }

  // TODO: Token deactivates after a 15 minute time period but may want to deactivate sooner
  Future<void>? logout() {
    return null;
  }
}