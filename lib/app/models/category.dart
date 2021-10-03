class Category {
  int? _id = 0;
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int? _parent;

  Category({int? id, required String name, DateTime? created, DateTime? modified, int? parent}) {
    _id = id;
    _name = name;
    _created = created;
    _modified = modified;
    _parent = parent;
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
    if ( _id != null ) {
      jsonMap['id'] = _id;
    }
    _created != null ? jsonMap['created'] = _created : jsonMap['created'] = DateTime.now();
    _modified != null ? jsonMap['modified'] = _modified : jsonMap['modified'] = DateTime.now();
    jsonMap['name'] = _name;
    jsonMap['parent'] = _parent;
    print(jsonMap.toString());
    return jsonMap;
  }

  int? get id => _id;
  String get name => _name;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  int? get parent => _parent;
}