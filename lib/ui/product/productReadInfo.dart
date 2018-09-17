import 'package:easylist/ui/product/addBarcodeProduct_Screen.dart';
import 'package:flutter/material.dart';

// * Pagina que exibe a informação do produto lido
// * Mostra a foto, codigo de barras e nome
class ProductReadPage extends StatefulWidget {
  final String barcode;
  final String productName;
  final String productImageUrl;

  ProductReadPage(this.barcode, this.productName, this.productImageUrl);

  @override
  _ProductReadPageState createState() => _ProductReadPageState(
      this.barcode, this.productName, this.productImageUrl);
}

class _ProductReadPageState extends State<ProductReadPage> {
  String barcodesState;
  String productNameState;
  String productImageUrlState;

  _ProductReadPageState(
      this.barcodesState, this.productNameState, this.productImageUrlState);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodyProductInfo(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionProductInfo(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("Product"),
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget bodyProductInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      color: Colors.redAccent,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(this.productImageUrlState),
                foregroundColor: Colors.black,
                radius: 85.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          ListTile(
              title: Text(
                this.productNameState,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("share");
                },
              )),
          ListTile(
            title: Text(this.barcodesState),
            subtitle: Text("Barcode value"),
          ),
          ListTile(
            title: Text("EAN-8"),
            subtitle: Text("Format"),
          ),
        ],
      ),
    );
  }

  FloatingActionButton floatingActionProductInfo(){
    return FloatingActionButton(
        child: Icon(
          Icons.check,
          size: 30.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddProductScreen(
                  this.barcodesState, this.productNameState)));
        },
      );
  }
}
