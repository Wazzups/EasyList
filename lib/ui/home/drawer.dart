import 'package:easylist/services/api_todo.dart';
import 'package:easylist/ui/profile/profilePage.dart';
import 'package:easylist/ui/todo/todoMain.dart';
import 'package:flutter/material.dart';
import '../../services/api_products.dart';
import '../about/aboutUsPage.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer(this.productApi);

  final ProductAPI productApi;

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

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.redAccent),
            accountName: new Text(_productApiListener.firebaseUser.displayName),
            accountEmail: new Text(_productApiListener.firebaseUser.email),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.redAccent,
              backgroundImage:
                  NetworkImage(_productApiListener.firebaseUser.photoUrl),
            ),
          ),
          new ListTile(
              leading: new Icon(Icons.inbox),
              title: new Text("Home"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: new Icon(Icons.assignment),
              title: new Text("ToDo"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ToDoMain(ToDoAPI(_productApiListener.firebaseUser))));
              }),
          new ListTile(
              leading: new Icon(Icons.person),
              title: new Text("Profile"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProfilePage(_productApiListener.firebaseUser)));
              }),
          new ListTile(
            leading: new Icon(Icons.help),
            title: new Text("About us"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutUsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
