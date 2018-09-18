import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easylist/ui/home/home.dart';
import '../../services/api_products.dart';

// * Pagina com o formulário para adicionar produtos
class AddProductScreen extends StatefulWidget {
  final String barcode;
  final String productName;
  AddProductScreen(this.barcode, this.productName);

  @override
  _AddProductScreenState createState() =>
      new _AddProductScreenState(this.barcode, this.productName);
}

class _AddProductScreenState extends State<AddProductScreen> {
  _AddProductScreenState(this.barcodesState, this.productNameState);

  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  var format = new intl.DateFormat.yMMMMd("en_US");
  List<String> _locations = <String>[
    '',
    'Pingo Doce',
    'Lidl',
    'Continente',
    'Jumbo'
  ];
  FirebaseUser firebaseUser;
  String productNameState;
  String barcodesState;
  String local = "";
  double price;
  int discount;

  @override
  void initState() {
    loadCurrentFirebaseUser();
    super.initState();
  }

  loadCurrentFirebaseUser() async {
    this.firebaseUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldState,
      appBar: appBarAddProduct(),
      body: addProductBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (_formState.currentState.validate()) {
            _formState.currentState.save();

            Firestore.instance.runTransaction((transaction) async {
              var dateTimeNowString = DateTime.now().toString();
              await transaction
                  .set(Firestore.instance.collection("products").document(), {
                'name': productNameState,
                'barcode': barcodesState,
                'local': local,
                'discount': discount,
                'price': price,
                'uid': firebaseUser.uid,
                'user': firebaseUser.email,
                'date': dateTimeNowString,
              });
            });

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MainHome(ProductAPI(this.firebaseUser))),
                (Route<dynamic> route) => false);
          }
        },
      ),
    );
  }

  AppBar appBarAddProduct() => AppBar(
        title: new Text("Add Product"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _formState.currentState.reset(),
          )
        ],
      );

  Widget addProductBody() => ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          new Form(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(
                    Icons.label,
                    color: Colors.red,
                  ),
                  title: new TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue:
                          productNameState != "" ? productNameState : "",
                      validator: (value) =>
                          value.isEmpty ? "Product Name Cannot be Empty" : null,
                      onSaved: (value) => productNameState = value,
                      maxLines: null,
                      decoration: new InputDecoration(
                          hintText: productNameState != ""
                              ? "$productNameState"
                              : "Product Name")),
                ),
                new ListTile(
                  leading: new Icon(
                    FontAwesomeIcons.barcode,
                    color: Colors.red,
                  ),
                  title: new TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: barcodesState != "" ? barcodesState : "",
                      validator: (value) =>
                          value.isEmpty ? "Barcode Cannot be Empty" : null,
                      onSaved: (value) => barcodesState = value,
                      maxLines: null,
                      decoration: new InputDecoration(
                          hintText: barcodesState != ""
                              ? "$barcodesState"
                              : "Barcode")),
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  title: new InputDecorator(
                    decoration: const InputDecoration(
                      hintText: 'Location',
                    ),
                    isEmpty: local == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        value: local,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            local = newValue;
                          });
                        },
                        items: _locations.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                new ListTile(
                  leading: new Icon(
                    FontAwesomeIcons.percentage,
                    color: Colors.red,
                  ),
                  title: new TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Discount Cannot be Empty" : null,
                      onSaved: (value) => discount = int.parse(value),
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(hintText: "Discount")),
                ),
                new ListTile(
                  leading: Icon(
                    Icons.euro_symbol,
                    color: Colors.red,
                  ),
                  title: new TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Price Cannot be Empty" : null,
                      onSaved: (value) => price = double.parse(value),
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(hintText: "Price")),
                ),
              ],
            ),
            key: _formState,
          ),
        ],
      );
}
