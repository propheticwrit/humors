class Survey {
  int? _id = 0;
  String _name = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int _category = 0;
  List<Question>? _questions = [];

  Survey({int? id, required String name, DateTime? created, DateTime? modified, required int category, List<Question>? questions}) {
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
    _created != null ? jsonMap['created'] = _created : jsonMap['created'] = DateTime.now();
    _modified != null ? jsonMap['modified'] = _modified : jsonMap['modified'] = DateTime.now();
    jsonMap['name'] = _name;
    jsonMap['category'] = _category;
    return jsonMap;
  }

  int? get id => _id;
  String get name => _name;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  int get category => _category;
  List<Question>? get surveyQuestions => _questions;
}

class Question {
  int? _id = 0;
  String _name = '';
  String _text = '';
  DateTime? _created = new DateTime.now();
  DateTime? _modified = new DateTime.now();
  int _survey = 0;
  List<Answer>? _answers = [];

  Question({int? id, required String name, required String text, DateTime? created, DateTime? modified, required int survey, List<Answer>? answers}) {
    _id = id;
    _name = name;
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
    _created != null ? jsonMap['created'] = _created : jsonMap['created'] = DateTime.now();
    _modified != null ? jsonMap['modified'] = _modified : jsonMap['modified'] = DateTime.now();
    jsonMap['name'] = _name;
    jsonMap['text'] = _text;
    jsonMap['survey'] = _survey;
    return jsonMap;
  }

  int? get id => _id;
  String get name => _name;
  String get text => _text;
  DateTime? get created => _created;
  DateTime? get modified => _modified;
  int get survey => _survey;
  List<Answer>? get questionAnswers => _answers;
}

class Answer {
  int? _id = 0;
  String? _label;
  String? _text;
  int _sequence = 0;
  String _style = '';
  int _question = 0;

  Answer({int? id, String? label, String? text, required int sequence, required String style, required int question}) {
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

  int? get id => _id;
  String? get label => _label;
  String? get text => _text;
  int get sequence => _sequence;
  String get style => _style;
  int get question => _question;
}