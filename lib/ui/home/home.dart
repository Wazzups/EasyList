import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/api_foodrepo.dart';
import '../../models/product.dart';
import '../../services/api_firebase.dart';
import 'drawer.dart';
import '../../services/api_products.dart';

class MainHome extends StatefulWidget {
  final ProductAPI productApi;
  MainHome(this.productApi);

  @override
  _MainHomeState createState() => _MainHomeState(this.productApi);
}

class _MainHomeState extends State<MainHome> {
  
  _MainHomeState(this._productApiListener);

  String barcode = "";
  APIFoodrepo apiFoodrepo = new APIFoodrepo();
  List<Product> _products = [];
  FirebaseAPI _firebaseApiListener;
  ProductAPI _productApiListener;
  FirebaseUser user;

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

  _reloadProducts() async {
    if (_firebaseApiListener != null) {
      final products = await _productApiListener.getAllProducts();
      setState(() {
        _products = products;
      });
    }
  }

  Widget _buildProductItem(BuildContext context, int index) {
    Product cat = _products[index];

    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () {},
              leading: new Hero(tag: index, child: Text("ds")),
              title: new Text(
                cat.name,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(cat.barcode),
              isThreeLine: true, // Less Cramped Tile
              dense: false, // Less Cramped Tile
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> refresh() {
    _reloadProducts();
    return new Future<Null>.value();
  }

  void showStuff() async {
    Map _data = await apiFoodrepo.getFoodInfo("222");
    print(_data["data"][0]["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new SideDrawer(),
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
                    builder: (BuildContext context) => SideDrawer()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: scan,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showStuff,
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
                        itemCount: _products.length,
                        itemBuilder: _buildProductItem)))
          ],
        ),
      ),
    );
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      Map _data = await apiFoodrepo.getFoodInfo(barcode);
      print(_data.toString());
    } catch (e) {
      debugPrint(e);
    }
  }
}
