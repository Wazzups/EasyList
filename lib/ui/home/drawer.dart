import 'package:easylist/services/api_todo.dart';
import 'package:easylist/ui/profile/profilePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easylist/ui/todo/todoMain.dart';
import 'package:flutter/material.dart';
import 'package:easylist/services/api_firebase.dart';
import '../../services/api_products.dart';
import '../about/aboutPage.dart';

class SideDrawer extends StatefulWidget {
  final ProductAPI productApi;

  SideDrawer(this.productApi);

  @override
  _SideDrawerState createState() => new _SideDrawerState(this.productApi);
}

class _SideDrawerState extends State<SideDrawer> {
  _SideDrawerState(this._productApiListener);

  ProductAPI _productApiListener;

  @override
  void initState() {
    super.initState();
  }

  void showColoredToast() {
    Fluttertoast.showToast(
        msg: "This is Colored Toast",
        toastLength: Toast.LENGTH_SHORT,
        bgcolor: "#e74c3c",
        textcolor: '#ffffff'
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.redAccent),
            accountName: Text(
              _productApiListener.firebaseUser.displayName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            accountEmail: Text(_productApiListener.firebaseUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.redAccent,
              backgroundImage:
                  NetworkImage(_productApiListener.firebaseUser.photoUrl),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.inbox,
              color: Colors.redAccent,
            ),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.redAccent),
            title: Text(
              "ToDo",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => new ToDoMain(
                        ToDoAPI(_productApiListener.firebaseUser)))),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.redAccent),
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfilePage(this._productApiListener.firebaseUser))),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: Text(
              "Sign up",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => FirebaseAPI.signOut(context),
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.redAccent),
            title: Text("About",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AboutPage())),
          ),
        ],
      ),
    );
  }
}
