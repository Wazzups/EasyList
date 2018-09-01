import 'package:meta/meta.dart';

class Product {
  int id;  
  String barcode;
  String name;
  String category;
  int discount;
  

  Product({
    @required this.id,
    @required this.barcode,
    @required this.name,
    this.category = "",
    @required this.discount,

  });

}