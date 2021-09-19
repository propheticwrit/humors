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

  Future<void> login();
  Future<void> apiCategories();
}

class MoodConnector implements Connector {

  var client = http.Client();

  final _userFetcher = PublishSubject<APIUser>();
  final _categoriesFetcher = PublishSubject<List<Category>>();

  Stream<APIUser> get apiUser => _userFetcher.stream;

  Stream<List<Category>> get categories => _categoriesFetcher.stream;

  dispose() {
    _userFetcher.close();
    _categoriesFetcher.close();
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
    print('API category response: ${response.body}');
    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var dict in jsonResponse) {
        print('dictionary: ${dict}');
        categories.add(Category.fromJson(dict));
      }
    } catch (Exception) {
      _categoriesFetcher.sink.addError('Error parsing response');
    }
    _categoriesFetcher.sink.add(categories);
  }

  // TODO: Token deactivates after a 15 minute time period but may want to deactivate sooner
  Future<void>? logout() {
    return null;
  }
}