import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => new _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
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
            accountName: new Text("Burhanuddin Rashid"),
            accountEmail: new Text("burhanrashid5253@gmail.com"),
            otherAccountsPictures: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  onPressed: () {})
            ],
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              //backgroundImage: new AssetImage("assets/profile_pic.jpg"),
            ),
          ),
          new ListTile(
              leading: new Icon(Icons.inbox),
              title: new Text("Inbox"),
              onTap: () {}),
          new ListTile(
              leading: new Icon(Icons.calendar_today),
              title: new Text("Today"),
              onTap: () {}),
          new ListTile(
            leading: new Icon(Icons.calendar_today),
            title: new Text("Next 7 Days"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
