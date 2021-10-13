import 'package:humors/app/models/survey.dart';
import 'package:intl/intl.dart';

class Category {
  int? _id = 0;
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int? _parent;
  List<Survey>? _surveys = [];

  Category({int? id, required String name, DateTime? created, DateTime? modified, int? parent, List<Survey>? surveys}) {
    _id = id;
    _name = name;
    _created = created;
    _modified = modified;
    _parent = parent;
    _surveys = surveys;
  }

  Category.fromJson(Map<String, dynamic> parsedJson) {
    _created = DateTime.parse(parsedJson['created']);
    _id = parsedJson['id'];
    _name = parsedJson['name'];
    _modified = DateTime.parse(parsedJson['modified']);
    _parent = parsedJson['parent'];

    List<Survey> temp = [];
    if (parsedJson.containsKey('surveys')) {
      for (int i = 0; i < parsedJson['surveys'].length; i++) {
        Survey survey = Survey.fromJson(parsedJson['surveys'][i]);
        temp.add(survey);
      }
    }
    _surveys = temp;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if ( _id != null ) {
      jsonMap['id'] = _id.toString();
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if ( _created != null ) {
      jsonMap['created'] = dateFormat.format(_created!);
    }
    if ( _modified != null ) {
      jsonMap['modified'] = dateFormat.format(_modified!);
    }
    jsonMap['name'] = _name;
    if ( _parent != null ) {
      jsonMap['parent'] = _parent.toString();
    }
    print(jsonMap.toString());
    return jsonMap;
  }

  int? get id => _id;
  String get name => _name;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  int? get parent => _parent;
  List<Survey>? get surveys => _surveys;

  set id(int? id) => _id = id;
  set name(String name) => _name = name;
  set created(DateTime? created) => _created = created;
  set modified(DateTime? modified) => _modified = modified;
  set parent(int? parent) => _parent = parent;
  set surveys(List<Survey>? surveys) => _surveys = surveys;
}