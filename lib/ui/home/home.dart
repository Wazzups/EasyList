import 'dart:async';
import 'package:easylist/ui/entry/entryPage.dart';
import 'package:easylist/ui/home/constantsPopUpButton.dart';
import 'package:easylist/ui/product/addBarcodeProduct_Screen.dart';
import 'package:easylist/ui/product/addPage.dart';
import 'package:easylist/ui/product/addProduct_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/api_foodrepo.dart';
import '../../models/product.dart';
import 'drawer.dart';
import '../../services/api_products.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class MainHome extends StatefulWidget {
  final ProductAPI productApi;
  MainHome(this.productApi);

  @override
  _MainHomeState createState() => _MainHomeState(this.productApi);
}

class _MainHomeState extends State<MainHome> {
  _MainHomeState(this._productApiListener);

  List<Product> _products = [];
  ProductAPI _productApiListener;
  FirebaseUser user;  
  String barcode = "";  
  APIFoodrepo apiFoodrepo = new APIFoodrepo();

  @override
  initState() {
    super.initState();
    _loadFromFirebase();
  }

  _loadFromFirebase() async {
    final products = await _productApiListener.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  Future<Null> refresh() {
    _reloadProducts();
    return new Future<Null>.value();
  }

  _reloadProducts() async {
    if (_productApiListener != null) {
      final products = await _productApiListener.getAllProducts();
      setState(() {
        _products = products;
      });
    }
  }

  
  Future scan2() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        debugPrint("Barcode: $barcode");
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future scanning() async {
    await scan2();
    print("O barcode e " + barcode);
    print("O this barcode e " + this.barcode);

    Map _data = await apiFoodrepo.getFoodInfo(barcode);
    print(_data.toString());
    print(_data["data"][0]["barcode"]);
    print(_data["data"][0]["display_name_translations"]["en"]);

    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddBarcodeProductScreen(_data["data"][0]["barcode"], _data["data"][0]["display_name_translations"]["en"])));
  }


  Widget _buildProductItem(BuildContext context, int index) {
    Product product = _products[index];
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () {},
              leading: new Hero(
                  tag: index,
                  child: CircleAvatar(
                    child: Text(
                      "${product.discount}%",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
              title: new Text(
                product.name,
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16.0),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(product.category.toUpperCase()),
                    new Text(
                      "Barcode " + product.barcode,
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
              isThreeLine: true, // Less Cramped Tile
              dense: false, // Less Cramped Tile
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new SideDrawer(_productApiListener),
      appBar: AppBar(
        title: Text("EasyList"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.dehaze),
          tooltip: "Navegation Menu",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SideDrawer(_productApiListener)));
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceActionAppBar,
            itemBuilder: (BuildContext context) {
              return ConstantsAppbar.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: PopupMenuButton<String>(
          icon: Icon(Icons.add),
          onSelected: choiceActionFloatingButton,
          itemBuilder: (BuildContext context) {
            return ConstantsFloatingButton.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AddPage()));
        },
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
                        itemCount: _products.length,
                        itemBuilder: _buildProductItem)))
          ],
        ),
      ),
    );
  }

  void choiceActionAppBar(String choice) async {
    if (choice == ConstantsAppbar.Settings) {
      print('Settings');
    } else if (choice == ConstantsAppbar.SignOut) {
      await _signOut();
    }
  }

  void choiceActionFloatingButton(String choice) {
    if (choice == ConstantsFloatingButton.Manual) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddBarcodeProductScreen("", "")));
    } else if (choice == ConstantsFloatingButton.Barcode) {
      scanning();
    }
  }

  Future _signOut() async {
    final user = await FirebaseAuth.instance.currentUser();
    print(user.email);
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
    
  }
}
