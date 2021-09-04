import 'package:flutter/cupertino.dart';
import 'package:humors/app/models/category.dart';

abstract class Connector {
  Future<void> addCategory(Category category);
}

class MoodConnector implements Connector {

  // var client = http.Client();
  // final _token = '73458d6dca8be781acf2ded11b0ecc3c3f23b204';
  // final String _url = 'api.clueo.net';

  MoodConnector({required String uid}) : assert(uid != null);

  final String uid = '';

  Future<void> addCategory(Category category) async {
    category.toJson();
    print('adding category');
  //  get future from api call using $uid
  }
  // Future<Categories> fetchCategories() async {
  //   var uri = Uri.http(_url, '/api/category');
  //   final response = await http.get(uri, headers: {'Authorization': 'Token ${_token}'});
  //
  //   print(response.body.toString());
  //   if (response.statusCode == 200) {
  //     // If the call to the server was successful, parse the JSON
  //     return Categories.fromJson(json.decode(response.body));
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load categories');
  //   }
  // }
  //
  // Future<Survey> fetchSurvey(int surveyId) async {
  //   var uri = Uri.http(_url, '/api/survey/${surveyId}');
  //   final response = await http.get(uri, headers: {'Authorization': 'Token ${_token}'});
  //
  //   print(response.body.toString());
  //   if (response.statusCode == 200) {
  //     // If the call to the server was successful, parse the JSON
  //     return Survey.fromJson(json.decode(response.body));
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load survey');
  //   }
  // }
}