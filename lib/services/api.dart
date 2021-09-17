import 'dart:async';

import 'package:humors/app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'api_path.dart';
import 'auth.dart';
import 'models/api_user.dart';

abstract class Connector {

  APIUser? get apiUser;

  Stream<APIUser?> login();
}

class MoodConnector implements Connector {

  var client = http.Client();

  APIUser? _apiUser;

  @override
  APIUser? get apiUser => _apiUser;

  Stream<APIUser?> login() => Stream.fromFuture(authenticate());

  Future<APIUser?> authenticate() async {

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
        return APIUser(username, email, refreshToken, accessToken);
      } else {
        throw new FormatException('Invalid response format');
      }
    }
  }

  // TODO: Token deactivates after a 15 minute time period but may want to deactivate sooner
  Future<void>? logout() {
    return null;
  }
}