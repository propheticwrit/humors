class Survey {
  String _name = '';
  DateTime _created = new DateTime.now();
  DateTime _modified = new DateTime.now();
  int _category = 0;
  List<Question> questions = [];

  Survey.fromJson(Map<String, dynamic> parsedJson) {
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
    questions = temp;
  }

  String get name => _name;
  DateTime get created => _created;
  DateTime get modified => _modified;
  int get category => _category;
  List<Question> get surveyQuestions => questions;
}

class Question {

  String _name = '';
  String _text = '';
  DateTime _created = new DateTime.now();
  DateTime _modified = new DateTime.now();
  int _survey = 0;
  List<Answer> answers = [];

  Question.fromJson(Map<String, dynamic> parsedJson) {
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
    answers = temp;
  }

  String get name => _name;
  String get text => _text;
  DateTime get created => _created;
  DateTime get modified => _modified;
  int get survey => _survey;
  List<Answer> get questionAnswers => answers;
}

class Answer {

  String? _label;
  String? _text;
  int _sequence = 0;
  String _style = '';
  int _question = 0;

  Answer.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['label'] != null)
      _label = parsedJson['label'];
    if (parsedJson['text'] != null)
      _text = parsedJson['text'];
    _sequence = parsedJson['sequence'];
    _style = parsedJson['style'];
    _question = parsedJson['question'];
  }

  String? get label => _label;
  String? get text => _text;
  int get sequence => _sequence;
  String get style => _style;
  int get question => _question;
}