import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBarcodeProductScreen extends StatefulWidget {
  final String barcode;
  final String productName;

  AddBarcodeProductScreen(this.barcode, this.productName);

  @override
  _AddBarcodeProductScreenState createState() =>
      new _AddBarcodeProductScreenState(this.barcode, this.productName);
}

class _AddBarcodeProductScreenState extends State<AddBarcodeProductScreen> {
  _AddBarcodeProductScreenState(this.barcodesState, this.productNameState);

  String productNameState;
  String barcodesState;
  String category = "";
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
        backgroundColor: Colors.redAccent,
        centerTitle: true,
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
                  leading: new Icon(Icons.label),
                  title: new TextFormField(
                      initialValue: productNameState != "" ? productNameState : "",
                      validator: (value) {
                        var msg = value.isEmpty
                            ? "Product Name Cannot be Empty"
                            : null;
                        return msg;
                      },
                      onSaved: (value) {
                        productNameState = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: new InputDecoration(
                          hintText: productNameState != ""
                              ? "$productNameState"
                              : "Product Name")),
                ),
                new ListTile(
                  leading: new Icon(Icons.turned_in),
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
                  leading: new Icon(Icons.attach_money),
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
                  leading: new Icon(Icons.view_column),
                  title: new TextFormField(
                      initialValue: barcodesState != "" ? barcodesState : "",
                      validator: (value) {
                        var msg =
                            value.isEmpty ? "Barcode Cannot be Empty" : null;
                        return msg;
                      },
                      onSaved: (value) {
                        barcodesState = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          hintText: barcodesState != ""
                              ? "$barcodesState"
                              : "Barcode")),
                ),
              ],
            ),
            key: _formState,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: new Icon(Icons.done, color: Colors.white),
          onPressed: () {
            if (_formState.currentState.validate()) {
              _formState.currentState.save();
              print("name" + this.productNameState + " " + barcodesState + " " + category + " " + "${discount.toString()}");

              Firestore.instance.runTransaction((transaction) async {
                await transaction
                    .set(Firestore.instance.collection("products").document(), {
                  'name': productNameState,
                  'category': category,
                  'discount': discount,
                  'barcode': barcodesState,
                });
              });

              Navigator.pop(context, true);
            }
          }),
    );
  }
}
