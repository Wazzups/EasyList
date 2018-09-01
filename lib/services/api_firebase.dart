import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseApi {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser firebaseUser;

  FirebaseApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<FirebaseApi> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuth =
        await googleUser.authentication;
    final FirebaseUser firebaseUser = await _auth.signInWithGoogle(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken);

    // Checks if google firebaseUser exists on Firestore Document users
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'email': firebaseUser.email
        });
      }
    }

    assert(firebaseUser.email != null);
    assert(firebaseUser.displayName != null);
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);

    return new FirebaseApi(firebaseUser);
  }
}
