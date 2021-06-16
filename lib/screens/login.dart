

import 'package:flutter/material.dart';
import 'file:///C:/Users/a.mikhailov/AndroidStudioProjects/flutter_commerce/lib/widgets/common.dart';
import 'package:flutter_commerce/db/auth.dart';
import 'package:flutter_commerce/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'signup.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance;

  Auth auth =Auth();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  User currentUser;
  SharedPreferences preferences;
  bool isLoading = false;
  bool isLogedin = false;
  bool hidePass = true;

 /* @override
  void initState() {
    super.initState();
    isSignedIn();
  }*/

  void isSignedIn() async {
    setState(() {
      isLoading = true;
    });
    currentUser = await firebaseAuth.currentUser;
    if(currentUser != null){
        setState(() => isLogedin = true);
    }

    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future handleSignIn() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    /*GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuthentication.idToken,accessToken: googleAuthentication.accessToken);
    User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;*/
    User firebaseUser = await auth.googleSignIn();

    if(firebaseUser!=null){
      // check if already sing in
      final QuerySnapshot resultQuery = await databaseReference
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentsSnapshot = resultQuery.docs;
      // save data to firestore if new user
      if(documentsSnapshot.length == 0) {
        await databaseReference
            .collection("users")
            .doc(firebaseUser.uid)
            .set({
          "nickname": firebaseUser.displayName,
          "photoURL": firebaseUser.photoURL,
          "id": firebaseUser.uid,
          "createdAt": DateTime.now().microsecondsSinceEpoch.toString(),
        })
            .then((_) => print("success!"));
        // write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoURL", currentUser.photoURL);
      }else{
        // write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", documentsSnapshot[0]["id"]);
        await preferences.setString("nickname", documentsSnapshot[0]["nickname"]);
        await preferences.setString("photoURL", documentsSnapshot[0]["photoURL"]);
      }
      Fluttertoast.showToast(msg: "Congratulations, sign in success.");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }
    // SignIn Not Success
    else {
      Fluttertoast.showToast(msg: "Try again, sign in failed.");
      this.setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
   //double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: user.status == Status.Authenticating ? Loading() : Stack(
        children: <Widget>[
          /*Image.asset(
            'images/back.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'images/lg.png',
                width: 280.0,
                height: 240.0,
              )),*/
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/cart.png',
                  width: 120.0,
//                height: 240.0,
                )),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [BoxShadow(
                        color: Colors.grey[350],
                        blurRadius: 20.0
                    )]
                ),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    icon: Icon(Icons.alternate_email),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Please make sure your email address is valid';
                                      else
                                        return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  obscureText: hidePass,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    icon: Icon(Icons.lock_outline),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The password field cannot be empty";
                                    } else if (value.length < 6) {
                                      return "the password has to be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      setState(() {
                                        hidePass = !hidePass;
                                      });
                                    }),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () {
                                   validate(user);
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Forgot password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
//                          Expanded(child: Container()),

                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 16.0),
                                    children: [
                                      TextSpan(text: "Don't have an account. Click here to "),
                                      TextSpan(text: "sign up",style: TextStyle(color: Colors.red)),
                                    ]
                                  ),
                                ),)
                                //child: Text("Don't have an account. Click here to sign up", textAlign: TextAlign.center, style: TextStyle(color: Colors.red),))
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Other sign in options", textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18.0),),
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Forgot password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      changeScreen(context,SignUp());
                                    },
                                    child: Text(
                                      "Create an account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: black),
                                    ))),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Or", style: TextStyle(fontSize: 20,color: Colors.grey),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child:   Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.red,
                            elevation: 0.0,

                              child: MaterialButton(
                                onPressed: (){handleSignIn();},
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text("Google",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20.0),),
                              ),
                          ),
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                  child: MaterialButton(
                                      onPressed: () {},
                                      child: Image.asset("images/fb.png", width: 60,)
                                  )),
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                  child: MaterialButton(
                                      onPressed: () {handleSignIn();},
                                      child: Image.asset("images/ggg.png", width: 60,)
                                  )),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Visibility(
            visible: isLoading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> validate(UserProvider user) async {
    if(_formKey.currentState.validate()){
      if(!await user.signIn(_email.text, _password.text))
        _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
    }
  }
}
