import 'package:flutter/material.dart';

// * Pagina informativa da aplicação e programador
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.update, color: Colors.black),
                      title: Text("Version"),
                      subtitle: Text("0.0.1"),
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text(
                        "Author",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.perm_identity, color: Colors.black),
                      title: Text("Pedro Espadinha"),
                      subtitle: Text("a18016"),
                    ),
                    ListTile(
                      leading: Icon(Icons.bug_report, color: Colors.black),
                      title: Text("Fork on Github"),
                      subtitle: Text("https://github.com/Wazzups/EasyList"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.black),
                      title: Text("Send an Email"),
                      subtitle: Text("pedromespadinha95@gmail.com"),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Any Question ?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon:
                                Image.asset("assets/images/facebook_logo.png"),
                            onPressed: () {},
                          ),
                          Text("https://facebook.com/pedromiguelwt")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("About EasyList Project",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        subtitle: Text('ESTGP - Escola Superior Tecnologia Gestão de Portalegre\nProjeto final de licenciatura'
                            "\n"),
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
