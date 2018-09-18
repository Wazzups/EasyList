import 'package:meta/meta.dart';

class User {
  String documentId;
  String email;
  String displayName;
  String uid;
  int likes;
  int posts;
  int todos;

  User({
    @required this.documentId,
    @required this.email,
    @required this.displayName,
    @required this.uid,
    @required this.likes,
    @required this.posts,
    @required this.todos,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'uid': uid,
        'likes': likes,
        'posts': posts,   
        'todos': todos,       
      };

  @override
  String toString() {
    return "User $uid named $email";
  }
}
