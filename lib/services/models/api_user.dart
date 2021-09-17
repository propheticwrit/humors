
class APIUser {

  APIUser(String username, String email, String refreshToken, String accessToken) {
    _username = username;
    _email = email;
    _refreshToken = refreshToken;
    _accessToken = accessToken;
  }

  String _username = '';
  String _email = '';
  String _refreshToken = '';
  String _accessToken = '';

  APIUser.fromJson(Map<String, dynamic> parsedJson) {
    _username = parsedJson['username'];
    _email = parsedJson['email'];
    if ( parsedJson.containsKey('tokens') ) {
      _refreshToken = parsedJson['tokens']['refresh'];
      _accessToken = parsedJson['tokens']['access'];
    }
  }

  String get username {
    return _username;
  }

  String get email {
    return _email;
  }

  String get refreshToken {
    return _refreshToken;
  }

  String get accessToken {
    return _accessToken;
  }
}