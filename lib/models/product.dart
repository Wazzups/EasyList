import 'package:meta/meta.dart';

class Product {
  String documentId;
  String barcode;
  int likes;
  String local;
  String name;
  String price;
  int discount;
  String uid;
  String userEmail;

  Product({
    @required this.documentId,
    @required this.barcode,
    @required this.likes,
    @required this.local,
    @required this.name,
    @required this.price,
    @required this.discount,
    @required this.uid,
    @required this.userEmail,
  });

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'discount': discount,
        'likes': likes,
        'local': local,
        'name': name,
        'price': price,
        'uid': uid,
        'user': userEmail,        
      };

  @override
  String toString() {
    return "Product $barcode named $name";
  }
}
