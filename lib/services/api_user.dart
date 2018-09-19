import 'dart:async';
import 'package:easylist/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// * Class para gerenciamento do utilizador e dados relativos 
class UserAPI {
  FirebaseUser firebaseUser;

  UserAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

  // * Verifica se o utilizador autenticado já existe na base de dados


  //* Adiciona novo utilizador à base de dados se não existir
  addNewUserToFirestore() {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(Firestore.instance.collection("users").document(), {
        'email': firebaseUser.email,
        'uid': firebaseUser.uid,
        'displayName': firebaseUser.displayName,
        'likes': 0,
        'posts': 0,
        'todos': 0,
      });
    });
  }

  // * Retorna o utilizador autenticado se existir na base de dados
  Future<List<User>> getUserAuthData() async {
    return (await Firestore.instance.collection('users').getDocuments())
        .documents
        .where((snapshot) => snapshot.data["uid"] == firebaseUser.uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  // * Retorna o utilizador autenticado by uid
  Future<List<User>> getUserAuthDatabyUid(String uid) async {
    return (await Firestore.instance.collection('users').getDocuments())
        .documents
        .where((snapshot) => snapshot.data["uid"] == uid)
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  //* Funçao de numero de Posts (1-Incrementa; 2-Decrementa)
  userincrementPostNumber(int option) async {
    List<User> users = [];
    users = await getUserAuthData();
    var userPosts;
    option == 1 ? userPosts = users[0].posts + 1 : userPosts = users[0].posts - 1;

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection("users").document(users[0].documentId),
          {
            'posts': userPosts,
          });
    });
  }
  //* Funçao de numero de todos (1-Incrementa; 2-Decrementa)
  userincrementTodoNumber(int option) async {
    List<User> users = [];
    users = await getUserAuthData();
    var userTodos;
    option == 1 ? userTodos = users[0].todos + 1 : userTodos = users[0].todos - 1;

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection("users").document(users[0].documentId),
          {
            'todos': userTodos,
          });
    });
  }
  
  userlikeNumber(String uid) async {
    List<User> users = [];
    users = await getUserAuthDatabyUid(uid);
    var userlikes = users[0].likes + 1 ;

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection("users").document(users[0].documentId),
          {
            'likes': userlikes,
          });
    });
  }

  StreamSubscription watch(User product, void onChange(User product)) {
    return Firestore.instance
        .collection('products')
        .document(product.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  // * Transforma o json em objectos da class
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
