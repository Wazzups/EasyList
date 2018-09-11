import 'dart:async';
import 'package:easylist/ui/product/addBarcodeProduct_Screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'addProduct_Screen.dart';
import '../../services/api_foodrepo.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  APIFoodrepo apiFoodrepo = new APIFoodrepo();
  String barcode = "";

  void showStuff() async {
    Map _data = await apiFoodrepo.getFoodInfo("222");
    print(_data["data"][0]["id"]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EasyList"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddProductScreen()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: scanning,
                )
              ],
            ),
          ),
        ));
  }
}
