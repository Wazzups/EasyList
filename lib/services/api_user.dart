import 'dart:async';
import 'package:easylist/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAPI {
  FirebaseUser firebaseUser;

  UserAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

    Future<List<User>> checkUserExist() async {
    return (await Firestore.instance.collection('users').getDocuments())
        .documents
        .where((snapshot) =>
            snapshot.data["uid"] == firebaseUser.uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  addUserToFirestore(){
    Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("users").document(), {
          'email': firebaseUser.email,
          'uid': firebaseUser.uid,
          'displayName': firebaseUser.displayName,
          'likes': 0,
          'posts': 0,
          'todos': 0,
        });
      });
  }

  Future<List<User>> getAllProducts() async {
    return (await Firestore.instance.collection('users').getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<List<User>> getAllProductsFromUserAuth() async {
    return (await Firestore.instance.collection('users').getDocuments())
        .documents
        .where((snapshot) =>
            snapshot.data["uid"] == firebaseUser.uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(User product, void onChange(User product)) {
    return Firestore.instance
        .collection('products')
        .document(product.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  User _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new User(
      documentId: snapshot.documentID,
      email: data["email"],
      displayName: data["displayName"],
      uid: data["uid"],
      likes: data['likes'],
      posts: data["posts"],
      todos: data["todos"],
    );
  }
}
