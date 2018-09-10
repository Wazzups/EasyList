import 'dart:async';
import 'package:easylist/ui/product/addPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/api_foodrepo.dart';
import '../../models/product.dart';
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

  List<Product> _products = [];
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
              leading:
                  new Hero(tag: index, child: Text("${product.discount}%")),
              title: new Text(
                product.name,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(product.barcode),
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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: (){},
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator
              .of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) => AddPage()));
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

}
