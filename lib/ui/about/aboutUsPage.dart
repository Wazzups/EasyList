import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About"),
        backgroundColor: Colors.redAccent,
      ),
      body: new Container(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(
            children: <Widget>[
              new Card(
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: new Icon(Icons.update, color: Colors.black),
                      title: new Text("Version"),
                      subtitle: new Text("0.0.1"),
                    )
                  ],
                ),
              ),
              new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: new Text("Author",
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    new ListTile(
                      leading:
                          new Icon(Icons.perm_identity, color: Colors.black),
                      title: new Text("Pedro Espadinha"),
                      subtitle: new Text("a18016"),
                      onTap: () {},
                    ),
                    new ListTile(
                        leading:
                            new Icon(Icons.bug_report, color: Colors.black),
                        title: new Text("Fork on Github"),
                        subtitle: new Text("https://github.com/Wazzups/EasyList"),
                        onTap: () {}),
                    new ListTile(
                        leading: new Icon(Icons.email, color: Colors.black),
                        title: new Text("Send an Email"),
                        subtitle: new Text("pedromespadinha95@gmail.com"),
                        onTap: () {}),
                  ],
                ),
              ),
              new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: new Text("Any Question ?",
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new IconButton(
                            icon: new Image.asset(
                                "assets/images/facebook_logo.png"),
                            onPressed: (){},
                          ),
                          new Text("https://facebook.com/pedromiguelwt")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: new Text("About EasyList Project",
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new ListTile(
                        subtitle: new Text(
                            '\nAplicação desenvolvida no ambito da  '
                            "\n\n\n"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
