import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => new _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String productName = "";
  String category = "";
  String barcode = "";
  int discount;
  int dueDate = new DateTime.now().millisecondsSinceEpoch;
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldState,
      appBar: new AppBar(
        title: new Text("Add Product"),
      ),
      body: new ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          new Form(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.book),
                  title: new TextFormField(
                      validator: (value) {
                        var msg = value.isEmpty
                            ? "Product Name Cannot be Empty"
                            : null;
                        return msg;
                      },
                      onSaved: (value) {
                        productName = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration:
                          new InputDecoration(hintText: "Product Name")),
                ),
                new ListTile(
                  leading: new Icon(Icons.book),
                  title: new TextFormField(
                      validator: (value) {
                        var msg =
                            value.isEmpty ? "Category Cannot be Empty" : null;
                        return msg;
                      },
                      onSaved: (value) {
                        category = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: new InputDecoration(hintText: "Category")),
                ),
                new ListTile(
                  leading: new Icon(Icons.book),
                  title: new TextFormField(
                      validator: (value) {
                        var msg =
                            value.isEmpty ? "Discount Cannot be Empty" : null;
                        return msg;
                      },
                      onSaved: (value) {
                        discount = int.parse(value);
                      },
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(hintText: "Discount")),
                ),
                new ListTile(
                  leading: new Icon(Icons.book),
                  title: new TextFormField(
                      validator: (value) {
                        var msg =
                            value.isEmpty ? "Barcode Cannot be Empty" : null;
                        return msg;
                      },
                      onSaved: (value) {
                        barcode = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(hintText: "Barcode")),
                ),
              ],
            ),
            key: _formState,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send, color: Colors.white),
          onPressed: () {
            if (_formState.currentState.validate()) {
              _formState.currentState.save();

              Firestore.instance.runTransaction((transaction) async {
                await transaction
                    .set(Firestore.instance.collection("products").document(), {
                  'name': productName,
                  'category': category,
                  'discount': discount,
                  'barcode' : barcode,
                });
              });

              Navigator.pop(context, true);
            }
          }),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null) {
      setState(() {
        dueDate = picked.millisecondsSinceEpoch;
      });
    }
  }
}
