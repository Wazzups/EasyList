import 'dart:async';
import '../models/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ToDoAPI {
  FirebaseUser firebaseUser;

  ToDoAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

  Future<List<Todo>> getAllTodo() async {
    return (await Firestore.instance.collection('todo').getDocuments())
        .documents
        .where((snapshot) =>
            snapshot.data["uid"] == firebaseUser.uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(Todo todo, void onChange(Todo todo)) {
    return Firestore.instance
        .collection('todo')
        .document(todo.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Todo _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new Todo(
      documentId: snapshot.documentID,
      title: data['title'],
      email: data['email'],
      todos: new List<String>.from(data['todos']),
      date: data['date'],
    );
  }
}
