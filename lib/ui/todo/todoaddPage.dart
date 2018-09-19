import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylist/models/todo.dart';
import 'package:flutter/material.dart';

class ToDoSecondMain extends StatefulWidget {
  final Todo todo;
  ToDoSecondMain(this.todo);

  @override
  _ToDoSecondMainState createState() => _ToDoSecondMainState(this.todo);
}

class _ToDoSecondMainState extends State<ToDoSecondMain> {
  _ToDoSecondMainState(this._todoListener);

  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  Todo _todoListener;
  String _taskTitle;
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
        .document(_todoListener.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Future<DocumentSnapshot> getTodoPicked() async {
    return (await Firestore.instance
        .collection('todo')
        .document(_todoListener.documentId)
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
      _todoListener = toDo;
    });
  }

  
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: Form(
              key: _formState,
              child: new TextFormField(
                validator: (value) {
                  var msg = value.isEmpty ? "Tittle Cannot be Empty" : null;
                  return msg;
                },
                onSaved: (String value) {
                  this._taskTitle = value;
                },
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Full Description', hintText: 'eg. Bolachas'),
              ),
            ))
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
            child: const Text('ADD'),
            onPressed: _addTaskToFirestore,
          )
        ],
      ),
    );
  }
  
  _addTaskToFirestore() {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();
      print(this._taskTitle);
      var tasks = _todoListener.todos;
      tasks.add(_taskTitle);

      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .update(Firestore.instance.collection("todo").document(_todoListener.documentId), {
          'todos': tasks,
        });
      });
      Navigator.of(context).pop();
      refresh();
    }
  }
  
  _removeTaskToFirestore(String task) {
  
      var tasks = _todoListener.todos;
      tasks.remove(task);

      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .update(Firestore.instance.collection("todo").document(_todoListener.documentId), {
          'todos': tasks,
        });
      });
      refresh();
    
  }

  Widget _buildTodosItem(BuildContext context, int index) {
    String toDos = _todoListener.todos[index];
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
              icon: Icon(Icons.delete_forever, color: Colors.white,),
              onPressed: ()=> _removeTaskToFirestore(toDos),
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
        title: Text("Tasks"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        
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
                        itemCount: _todoListener.todos.length,
                        itemBuilder: _buildTodosItem)))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Todo",
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: _showDialog,
      ),
    );
  }
}
