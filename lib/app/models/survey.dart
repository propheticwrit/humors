import 'package:intl/intl.dart';

class Survey {
  String _id = '';
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  String _category = '';
  List<Question>? _questions = [];

  Survey({required String id, required String name, DateTime? created, DateTime? modified, required String category, List<Question>? questions}) {
    _id = id;
    _name = name;
    _created = created;
    _modified = modified;
    _category = category;
    _questions = questions;
  }

  Survey.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _name = parsedJson['name'];
    _created = DateTime.parse(parsedJson['created']);
    _modified = DateTime.parse(parsedJson['modified']);
    _category = parsedJson['category'];

    List<Question> temp = [];
    if (parsedJson.containsKey('questions')) {
      for (int i = 0; i < parsedJson['questions'].length; i++) {
        Question question = Question.fromJson(parsedJson['questions'][i]);
        temp.add(question);
      }
    }
    _questions = temp;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if ( _id != null ) {
      jsonMap['id'] = _id;
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if ( _created != null ) {
      jsonMap['created'] = dateFormat.format(_created!);
    }
    if ( _modified != null ) {
      jsonMap['modified'] = dateFormat.format(_modified!);
    }
    jsonMap['name'] = _name;
    jsonMap['category'] = _category;
    return jsonMap;
  }

  String get id => _id;
  String get name => _name;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  String get category => _category;
  List<Question>? get surveyQuestions => _questions;

  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set created(DateTime? created) => _created = created;
  set modified(DateTime? modified) => _modified = modified;
  set category(String category) => _category = category;
  set surveyQuestions(List<Question>? questions) => _questions = questions;
}

class Question {
  String _id = '';
  String _name = '';
  String _text = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  String _survey = '';
  List<Answer>? _answers = [];

  Question({required String id, required String name, required String text, DateTime? created, DateTime? modified, required String survey, List<Answer>? answers}) {
    _id = id;
    _name = name;
    _text = text;
    _created = created;
    _modified = modified;
    _survey = survey;
    _answers = answers;
  }

  Question.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _name = parsedJson['name'];
    _text = parsedJson['text'];
    _created = DateTime.parse(parsedJson['created']);
    _modified = DateTime.parse(parsedJson['modified']);
    _survey = parsedJson['survey'];

    List<Answer> temp = [];
    if (parsedJson.containsKey('answers')) {
      for (int i = 0; i < parsedJson['answers'].length; i++) {
        Answer answer = Answer.fromJson(parsedJson['answers'][i]);
        temp.add(answer);
      }
    }
    _answers = temp;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if ( _id != null ) {
      jsonMap['id'] = _id;
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if ( _created != null ) {
      jsonMap['created'] = dateFormat.format(_created!);
    }
    if ( _modified != null ) {
      jsonMap['modified'] = dateFormat.format(_modified!);
    }
    jsonMap['name'] = _name;
    jsonMap['text'] = _text;
    jsonMap['survey'] = _survey;
    return jsonMap;
  }

  String get id => _id;
  String get name => _name;
  String get text => _text;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  String get survey => _survey;
  List<Answer>? get answers => _answers;

  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set text(String text) => _text = text;
  set created(DateTime? created) => _created = created;
  set modified(DateTime? modified) => _modified = modified;
  set survey(String survey) => _survey = survey;
  set answers(List<Answer>? answers) => _answers = answers;
}

class Answer {
  String _id = '';
  String? _label;
  String? _text;
  int _sequence = 0;
  String _style = '';
  String _question = '';

  Answer({required String id, String? label, String? text, required int sequence, required String style, required String question}) {
    _id = id;
    _label = label;
    _text = text;
    _sequence = sequence;
    _style = style;
    _question = question;
  }

  Answer.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _label = parsedJson['label'];
    _text = parsedJson['text'];
    _sequence = parsedJson['sequence'];
    _style = parsedJson['style'];
    _question = parsedJson['question'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if ( _id != null ) {
      jsonMap['id'] = _id;
    }
    jsonMap['label'] = _label;
    jsonMap['text'] = _text;
    jsonMap['sequence'] = _sequence;
    jsonMap['style'] = _style;
    jsonMap['question'] = _question;
    return jsonMap;
  }

  String get id => _id;
  String? get label => _label;
  String? get text => _text;
  int get sequence => _sequence;
  String get style => _style;
  String get question => _question;

  set id(String id) => _id = id;
  set label(String? name) => _label = label;
  set text(String? text) => _text = text;
  set sequence(int sequence) => _sequence = sequence;
  set style(String style) => _style = style;
  set question(String question) => _question = question;
}