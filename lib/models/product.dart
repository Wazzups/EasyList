import 'package:meta/meta.dart';

class Product {
  String documentId;
  String barcode;
  String name;
  String category;
  int discount;
  

  Product({
    @required this.documentId,
    @required this.barcode,
    @required this.name,
    @required this.category,
    @required this.discount,

  });

  
  @override
  String toString() {
    return "Product $barcode is named $name";
  }



}