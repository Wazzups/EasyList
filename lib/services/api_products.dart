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

  Future<List<Product>> getAllProductsFromUserAuth() async {
    return (await Firestore.instance.collection('products').getDocuments())
        .documents
        .where((snapshot) =>
            snapshot.data["uid"] == firebaseUser.uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(Product product, void onChange(Product product)) {
    return Firestore.instance
        .collection('products')
        .document(product.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Product _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new Product(
      documentId: snapshot.documentID,
      barcode: data["barcode"],
      likes: data["likes"],
      local: data["local"],
      name: data['name'],
      price: data["price"],
      discount: data["discount"],
      uid: data["uid"],
      userEmail: data["user"],
      date: data["date"]
    );
  }
}
