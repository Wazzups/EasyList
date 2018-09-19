import 'dart:async';
import 'package:easylist/models/users.dart';
import 'package:easylist/services/api_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easylist/ui/home/constantsPopUpButton.dart';
import 'package:easylist/ui/product/addProductPage.dart';
import 'package:easylist/ui/product/productReadInfo.dart';
import 'drawer.dart';
import '../../services/api_foodrepo.dart';
import '../../models/product.dart';
import '../../services/api_products.dart';

class MainHome extends StatefulWidget {
  MainHome(this.productApi);

  final ProductAPI productApi;

  @override
  _MainHomeState createState() => _MainHomeState(this.productApi);
}

class _MainHomeState extends State<MainHome> {
  _MainHomeState(this._productApiListener);

  APIFoodrepo apiFoodrepo = new APIFoodrepo();
  ProductAPI _productApiListener;
  List<Product> _products = [];
  FirebaseUser user;
  UserAPI _userAPI;
  String _barcode = "";
  int _choice = 1;
  List<User> _users = [];

  @override
  initState() {
    super.initState();
    loadUserData();
    _loadAllProducts(); 
  }

  loadUserData() async{
    var userAPI = new UserAPI(this._productApiListener.firebaseUser);
    var users = await userAPI.getUserAuthData();
    setState(() {
          _users = users;
          _userAPI = userAPI;
        });
    }

  // * Load de todos os produtos
  _loadAllProducts() async {
    final products = await _productApiListener.getAllProducts();
    products.sort((b, a) => a.date.compareTo(b.date));
    setState(() {
      _products = products;
    });
  }

  // * Load do produtos adicionados pelo utilizador autenticado
  _loadHistoryProducts() async {
    final products = await _productApiListener.getAllProductsFromUserAuth();
    products.sort((b, a) => a.date.compareTo(b.date));
    setState(() {
      _products = products;
    });
  }

  Future<Null> refresh() {
    _reloadProducts();
    return new Future<Null>.value();
  }

  // * Faz reload dependendo da escolha
  _reloadProducts() async {
    if (_productApiListener != null) {
      if (_choice == 1) {
        _loadAllProducts();
      } else if (_choice == 2) {
        _loadHistoryProducts();
      }
    }
  }

  Future scanning() async {
    await scan();

    Map _data = await apiFoodrepo.getFoodInfo(this._barcode);
    print(_data.toString());
    print(_data["data"][0]["barcode"]);
    print(_data["data"][0]["display_name_translations"]["en"]);
    print(_data["data"][0]["images"][1]["thumb"]);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ProductReadPage(
            _data["data"][0]["barcode"],
            _data["data"][0]["display_name_translations"]["en"],
            _data["data"][0]["images"][1]["thumb"])));
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
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _userAPI.userlikeNumber(product.uid);
                },
              ),
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
                    new Text(product.local.toUpperCase()),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    new Text(
                      "Price " + product.price.toString() + "€",
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
            onSelected: choiceActionFilter,
            icon: Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return ConstantsFilter.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          PopupMenuButton<String>(
            onSelected: choiceActionOrder,
            icon: Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return ConstantsOrder.choices.map((String choice) {
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
                child: choice == "Manual"
                    ? Center(child: Icon(Icons.pan_tool))
                    : Center(child: Icon(FontAwesomeIcons.barcode)),
              );
            }).toList();
          },
        ),
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: () {},
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

  choiceActionFilter(String choice) {
    if (choice == ConstantsFilter.History) {
      _loadHistoryProducts();
      _choice = 2;
    } else if (choice == ConstantsFilter.All) {
      _loadAllProducts();
      _choice = 1;
    }
  }

  choiceActionOrder(String choice) {
    if (choice == ConstantsOrder.Location) {
      setState(() {
        _products.sort((a, b) => a.local.compareTo(b.local));
      });
    } else if (choice == ConstantsOrder.Price) {
      setState(() {
        _products.sort((a, b) => a.price.compareTo(b.price));
      });
    }
  }

  choiceActionFloatingButton(String choice) {
    if (choice == ConstantsFloatingButton.Manual) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddProductScreen("", "")));
    } else if (choice == ConstantsFloatingButton.Barcode) {
      scanning();
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this._barcode = barcode;
        debugPrint("Barcode: $barcode");
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this._barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this._barcode = 'Unknown error: $e');
    }
  }
}
