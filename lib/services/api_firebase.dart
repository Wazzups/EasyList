import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easylist/ui/entry/entryPage.dart';

class FirebaseAPI {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser firebaseUser;

  //Faz GoogleSign e retorna o user logado
  static Future<FirebaseUser> signInWithGoogle() async {
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
    print(user.displayName);

    return currentUser;
  }

  static Future signOut(BuildContext context) async {
    final user = await FirebaseAuth.instance.currentUser();
    print(user.email);
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => EntryPage()),
        (Route<dynamic> route) => false);
  }

  static Future registUserDataFirestore(FirebaseUser firebaseUser) async {
    
    Firestore.instance.runTransaction((transaction) async {
      var dateTimeNowString = DateTime.now().toString();
      await transaction
          .set(Firestore.instance.collection("users").document(), {
        'email': firebaseUser.email,
        'displayName': firebaseUser.displayName,
        'local': firebaseUser,
        'likes': 0,
        'Posts': 0,
        'tasks': firebaseUser.uid,
        'uid': firebaseUser.uid,
        'date': dateTimeNowString,
      });
    });
  }
}
