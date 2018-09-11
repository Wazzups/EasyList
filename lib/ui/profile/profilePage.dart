import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 
class ProfilePage extends StatefulWidget {  
  FirebaseUser firebaseUser;
  ProfilePage(this.firebaseUser);

  @override
  _ProfilePageState createState() => new _ProfilePageState(this.firebaseUser);
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseUser firebaseUserListener;
  _ProfilePageState(this.firebaseUserListener);

  @override
  void initState() {
    super.initState();
  }

  Widget profileColumn() => Container(
        color: Colors.redAccent.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(firebaseUserListener.photoUrl),
                    foregroundColor: Colors.black,
                    radius: 40.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Text(
              firebaseUserListener.displayName,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              firebaseUserListener.email,
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
          ],
        ),
      );

  Widget followColumn() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              title: Text("1.6k"),
              subtitle: Text("dsa"),
            ),
            ListTile(
              title: Text("2.5K"),
              subtitle: Text("Followers"),
            ),
            ListTile(
              title: Text("10K"),
              subtitle: Text("10K"),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(child: profileColumn()),
    );
  }
}
