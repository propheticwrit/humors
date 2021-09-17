

class APIPath {

  static final String url = 'api.clueo.net';

  static login() => '/social_auth/google/';

  static user_list(String element) => '/api/${element}';
}