import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAPIUser {
  FirebaseUser firebaseUser;

  FirebaseAPIUser(FirebaseUser user) {
    this.firebaseUser = user;
  }
}
