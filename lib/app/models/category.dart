class Category {
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int? _parent;

  Category(String name, DateTime? created, DateTime? modified, int? parent) {
    _name = name;
    if ( created != null ) {
      _created = created;
    }
    if ( modified != null ) {
      _modified = modified;
    }
    if ( parent != null ) {
      _parent = parent;
    }
  }

  Category.fromJson(Map<String, dynamic> parsedJson) {
    _created = DateTime.parse(parsedJson['created']);
    _name = parsedJson['name'];
    _modified = DateTime.parse(parsedJson['modified']);
    if (parsedJson['parent'] != null) {
      _parent = int.parse(parsedJson['parent']);
    } else {
      _parent = null;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if (_created != null) {
      jsonMap['created'] = _created;
    } else {
      jsonMap['created'] = DateTime.now();
    }
    if (_modified != null) {
      jsonMap['modified'] = _modified;
    } else {
      jsonMap['modified'] = DateTime.now();
    }
    jsonMap['name'] = _name;
    jsonMap['parent'] = _parent;
    print(jsonMap.toString());
    return jsonMap;
  }

  String get name => _name;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  int? get parent => _parent;
}

class Categories {

  List<Category> _categories = [];

  Categories.fromJson(List<dynamic> parsedJson) {
    print(parsedJson.toString());

    List<Category> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      Category category = Category.fromJson(parsedJson[i]);
      temp.add(category);
    }
    _categories = temp;
  }

  List<Category> get categories => _categories;
}