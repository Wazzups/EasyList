import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylist/models/todo.dart';
import 'package:easylist/ui/entry/entryPage.dart';
import 'package:easylist/ui/home/constantsPopUpButton.dart';
import 'package:easylist/ui/todo/todoaddPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/api_todo.dart';
import 'package:intl/intl.dart' as intl;

class ToDoMain extends StatefulWidget {
  final ToDoAPI todoApi;
  ToDoMain(this.todoApi);

  @override
  _ToDoMainState createState() => _ToDoMainState(this.todoApi);
}

class _ToDoMainState extends State<ToDoMain> {
  TextEditingController _c = new TextEditingController();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  _ToDoMainState(this._todoApiListener);
  ToDoAPI _todoApiListener;
  String todotitle;
  List<String> todoslist = [];
  String deletetodo;

  List<Todo> _toDos = [];

  @override
  initState() {
    super.initState();
    _loadFromFirebase();
  }

  _loadFromFirebase() async {
    final toDos = await _todoApiListener.getAllTodo();
    setState(() {
      _toDos = toDos;
    });
  }

  Future<Null> refresh() {
    _reloadProducts();
    _deleteToDoFirestore(this.deletetodo);
    return new Future<Null>.value();
  }

  _reloadProducts() async {
    if (_todoApiListener != null) {
      final toDos = await _todoApiListener.getAllTodo();
      setState(() {
        _toDos = toDos;
      });
    }
  }

  Widget _buildTodosItem(BuildContext context, int index) {
    Todo toDos = _toDos[index];
    return new Card(
      color: Colors.redAccent.shade100,
      child: ListTile(
        onTap: (){
          Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ToDoSecondMain(toDos.documentId)));
        },
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent,
          backgroundImage: NetworkImage(_todoApiListener.firebaseUser.photoUrl),
        ),
        title: new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
              toDos.title.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                setState(() {
                  deletetodo = toDos.documentId;
                });

                debugPrint(this.deletetodo);
              },
            )
          ],
        ),
        subtitle: Text("Date created: " + toDos.date),
      ),
    );
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
                  this.todotitle = value;
                },
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
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
            child: const Text('OPEN'),
            onPressed: _addToDoFirestore,
          )
        ],
      ),
    );
  }

  _addToDoFirestore() {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();
      print(this.todotitle);
      var format = new intl.DateFormat.yMMMMd("en_US");
      var dateTime = new DateTime.now();
      var dateString = format.format(dateTime);

      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("todo").document(), {
          'title': todotitle,
          'date': dateString,
          'todos': todoslist,
          'email': _todoApiListener.firebaseUser.email,
        });
      });
      Navigator.of(context).pop();
    }
  }

  _deleteToDoFirestore(String documentId) {
    Firestore.instance.runTransaction((transaction) async {
      await transaction
          .delete(Firestore.instance.collection("todo").document(documentId));
    });
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
              debugPrint(_c.toString());
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
                        itemCount: _toDos.length,
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
