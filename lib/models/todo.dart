import 'package:meta/meta.dart';

class Todo {
  String documentId;
  String title;
  String date;  
  String email;
  final List<String> todos;

  Todo({
    @required this.documentId,
    @required this.title,
    @required this.date,    
    @required this.email,
    @required this.todos,

  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'todos': todos,        
        'email': email,
        'date' : date,
      };

  @override
  String toString() {
    return "Todo name $title";
  }
}
