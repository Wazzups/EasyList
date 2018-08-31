import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/api_foodrepo.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  String barcode = "";
  APIFoodrepo apiFoodrepo = new APIFoodrepo();

  @override
  initState() {
    super.initState();
  }

  void showStuff() async {
    Map _data = await apiFoodrepo.getFoodInfo("222");
    print(_data["data"][0]["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EasyList"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        leading: Icon(Icons.dehaze),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showStuff,
          )
        ],
      ),
    );
  }


  Future scan() async {
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
}
