import 'dart:async';
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
    final FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return new FirebaseApi(user);
  }
}
