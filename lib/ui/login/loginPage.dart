import 'package:easylist/models/users.dart';
import 'package:easylist/services/api_user.dart';
import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home.dart';
import '../../services/api_firebase.dart';
import '../../services/api_products.dart';

// * Pagina de autenticação
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;  
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
  }

  _loginFirebaseGoogle() async {
    final firebaseUser = await FirebaseAPI.signInWithGoogle();
    debugPrint("GoogleUser Authenticated UID = " + firebaseUser.uid);
    UserAPI userAPI = new UserAPI(firebaseUser);
    _users = await userAPI.checkUserExist();
    if (_users.length == 0) {
      userAPI.addUserToFirestore();
    }
    print(_users.toString());
    if (firebaseUser != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  new MainHome(ProductAPI(firebaseUser))));
    }
  }

  String _emailValidation(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
  }

  String _passwordValidation(String value) {
    if (value.length < 8) return 'The Password must be at least 8 characters.';
    return null;
  }

  bool validation() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      print('Email: $_email');
      print('Password: $_password');

      return true;
    }
    return false;
  }

  validationAndLogin() async {
    if (validation()) {
      try {
        FirebaseUser firebaseUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        debugPrint("UserLogin UID = " + firebaseUser.uid);
      } catch (e) {
        debugPrint(e);
        AlertDialog();
      }
    }
  }

  Widget loginPage(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.15), BlendMode.dstATop),
          image: AssetImage('assets/images/list.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Form(
        key: _loginFormKey,
        child: new ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50.0),
              child: Center(
                child: Icon(
                  Icons.assignment,
                  color: Colors.red,
                  size: 55.0,
                ),
              ),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.redAccent,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.mail_outline,
                          color: Colors.red,
                        ),
                        border: InputBorder.none,
                        hintText: 'example@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: _emailValidation,
                      onSaved: (value) => this._email = value,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.redAccent,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.red,
                        ),
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: _passwordValidation,
                      onSaved: (value) => this._password = value,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new FlatButton(
                    child: new Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Colors.redAccent,
                      onPressed: validationAndLogin,
                      child: new Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: Text(
                                "LOG IN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                  Text(
                    "OR CONNECT WITH",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.only(left: 100.0, right: 100.0, top: 20.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: Color(0Xffdb3236),
                onPressed: () {},
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => _loginFirebaseGoogle(),
                        padding: EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: new Row(
                          children: <Widget>[
                            Icon(
                              const IconData(0xea88, fontFamily: 'icomoon'),
                              color: Colors.white,
                              size: 15.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                            ),
                            Text(
                              "GOOGLE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: loginPage(context));
  }
}
