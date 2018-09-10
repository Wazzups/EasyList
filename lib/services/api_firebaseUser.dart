import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAPIUser {
  FirebaseUser firebaseUser;

  FirebaseAPIUser(FirebaseUser user) {
    this.firebaseUser = user;
  }

  @override
    String toString() {
      return "UserUid " + firebaseUser.uid + "Display Name " + firebaseUser.displayName;
    }
}
