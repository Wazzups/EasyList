import 'package:flutter/material.dart';

Widget HomePage(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      color: Colors.redAccent,
      image: DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.dstATop),
        image: AssetImage("assets/images/list.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 140.0),
          child: Center(
            child: Icon(
              Icons.assignment,
              color: Colors.white,
              size: 55.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Easy",
                style: TextStyle(
                    color: Colors.white, fontSize: 40.0, fontFamily: "bpp"),
              ),
              Text(
                "List",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "bpp"),
              ),              
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 8.0),
          child: Text(
                "No need to worry with EasyList",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontFamily: "lato"),
              ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.redAccent,
                  highlightedBorderColor: Colors.white,
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.white,
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text("LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
