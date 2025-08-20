class Question{
  int id;
  String questionText;
  Map<String, String> options;
  String answer;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.answer,
  });
}