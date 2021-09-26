class Category {
  int _id = 0;
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int? _parent;

  Category(int id, String name, DateTime? created, DateTime? modified, int? parent) {
    _id = id;
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
    _id = parsedJson['id'];
    _name = parsedJson['name'];
    _modified = DateTime.parse(parsedJson['modified']);
    _parent = parsedJson['parent'];
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
    jsonMap['id'] = _id;
    jsonMap['name'] = _name;
    jsonMap['parent'] = _parent;
    print(jsonMap.toString());
    return jsonMap;
  }

  int get id => _id;
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