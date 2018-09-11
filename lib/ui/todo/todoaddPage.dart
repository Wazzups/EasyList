import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylist/models/todo.dart';
import 'package:flutter/material.dart';

class ToDoSecondMain extends StatefulWidget {
  final String todoDocumentId;
  ToDoSecondMain(this.todoDocumentId);

  @override
  _ToDoSecondMainState createState() =>
      _ToDoSecondMainState(this.todoDocumentId);
}

class _ToDoSecondMainState extends State<ToDoSecondMain> {
  _ToDoSecondMainState(this._todoDocumentIdListener);

  String _todoDocumentIdListener;
  String todotitle;
  List<String> todoslist = [];
  String deletetodo;

  Todo _toDo;

  @override
  initState() {
    super.initState();
    _loadFromFirebase();
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

  StreamSubscription watch(Todo todo, void onChange(Todo todo)) {
    return Firestore.instance
        .collection('todo')
        .document(_todoDocumentIdListener)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Future<DocumentSnapshot> getTodoPicked() async {
    return (await Firestore.instance
        .collection('todo')
        .document(_todoDocumentIdListener)
        .get());
  }

  _loadFromFirebase() async {
    final snapshot = await getTodoPicked();
    final toDo = _fromDocumentSnapshot(snapshot);
    setState(() {
      _toDo = toDo;
    });
    debugPrint(_toDo.date);
  }

  Future<Null> refresh() {
    _reloadProducts();
    return new Future<Null>.value();
  }

  _reloadProducts() async {
    final snapshot = await getTodoPicked();
    final toDo = _fromDocumentSnapshot(snapshot);
    setState(() {
      _toDo = toDo;
    });
  }

  Widget _buildTodosItem(BuildContext context, int index) {
    String toDos = _toDo.todos[index];
    return new Card(
      color: Colors.redAccent.shade100,
      child: ListTile(
        onTap: () {},
        title: new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
              toDos,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EasyList"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              debugPrint(_toDo.date);
            },
          )
        ],
      ),
      body: new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Column(
          children: <Widget>[
            Flexible(
                child: new RefreshIndicator(
                    onRefresh: refresh,
                    child: new ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _toDo.todos.length,
                        itemBuilder: _buildTodosItem)))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Todo",
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: () {},
      ),
    );
  }
}
