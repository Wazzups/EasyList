import 'package:flutter/material.dart';
import 'package:easylist/services/api_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// * Página de perfil do user autenticado
class ProfilePage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  ProfilePage(this.firebaseUser);

  @override
  _ProfilePageState createState() => new _ProfilePageState(this.firebaseUser);
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseUser _firebaseUserListener;
  _ProfilePageState(this._firebaseUserListener);
  int _likes;
  int _posts;
  int _todos;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  //* retorna o utiliador logado do firestore e atribui as variaveis de perfil
  loadUserData() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var userAPI = new UserAPI(firebaseUser);
    var users = await userAPI.getUserAuthData();
    setState(() {
      _likes = users[0].likes;
      _posts = users[0].posts;
      _todos = users[0].todos;
    });
  }

  Widget profileColumn() => ListView(children: <Widget>[
        Container(
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
                      backgroundImage:NetworkImage(_firebaseUserListener.photoUrl),
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
                _firebaseUserListener.displayName,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _firebaseUserListener.email,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.timeline,
                color: Colors.redAccent,
                size: 35.0,
              ),
              title: Text(
                _posts == null ? "loading..." : "$_posts",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: Text("Posts"),
            ),
            ListTile(
              leading: Icon(
                Icons.thumb_up,
                color: Colors.redAccent,
                size: 35.0,
              ),
              title: Text(
                _likes == null ? "loading..." : "$_likes",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: Text("Likes"),
            ),
            ListTile(
              leading: Icon(
                Icons.assignment,
                color: Colors.redAccent,
                size: 35.0,
              ),
              title: Text(
                _todos == null ? "loading..." : "$_todos",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: Text("ToDos"),
            )
          ],
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: profileColumn(),
    );
  }
}
