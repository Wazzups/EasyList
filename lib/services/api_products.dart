import 'dart:async';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductAPI {
  FirebaseUser firebaseUser;

  ProductAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

  Future<List<Product>> getAllProducts() async {
    return (await Firestore.instance.collection('products').getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(Product product, void onChange(Product product)) {
    return Firestore.instance
        .collection('cats')
        .document(product.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Product _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new Product(
      documentId: snapshot.documentID,
      name: data['name'],
      barcode: data["barcode"],
      category: data["category"],
      discount: data["discount"],
    );
  }
}
