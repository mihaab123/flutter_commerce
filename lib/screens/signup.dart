import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/auth.dart';
import 'package:flutter_commerce/db/users.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  Auth auth =Auth();
  final UserServices _userServices = UserServices();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String gender = "male";
  String groupValue = "male";
  bool hidePass = true;
  bool loading = false;

  void valueChanged(String value){
    if(value == "male"){
      groupValue = value;
      gender = value;
    }else if(value == "female"){
      groupValue = value;
      gender = value;
    }
    setState(() {

    });
  }
  Future validateForm() async {
    final FormState formState = _formKey.currentState;
    //firebaseAuth.signOut();
    if (formState.validate()) {
      formState.reset();
      final User user = firebaseAuth.currentUser;
      if (user == null) {
        firebaseAuth
            .createUserWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text)
            .then((user) => {
              _database.collection("users").doc(user.user.uid.toString()).set(
                {
                  "nickname": _nameTextController.text,
                  "email": _emailTextController.text,
                  "id": user.user.uid.toString(),
                  "gender": gender,
                  "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
                }
              ).catchError((e) => {
               debugPrint(e.toString())
              })
       /*   _userServices.createUser(
              {
                "nickname": _nameTextController.text,
                "email": _emailTextController.text,
                "id": user.user.uid.toString(),
                "gender": gender,
                "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
              },
              user.user.uid.toString()
          )*/
        }).catchError((err) => {
          debugPrint(err.toString())
        });
        changeScreenReplacement(context,HomePage());
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));*/

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[350],
                      blurRadius: 20.0
                    )]
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                         Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  'images/cart.png',
                                  width: 50.0,
//                height: 240.0,
                                )),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _nameTextController,
                                    decoration: InputDecoration(
                                      hintText: "full_name".tr(),
                                      icon: const Icon(Icons.person_outline),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "full_name_empty_error".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: ListTile(
                                        title: Text(
                                          "male".tr(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(color: black),
                                        ),
                                        trailing: Radio(
                                            value: "male",
                                            groupValue: groupValue,
                                            onChanged: (String e) => valueChanged(e)),
                                      )),
                                  Expanded(
                                      child: ListTile(
                                        title: Text(
                                          "female".tr(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(color: black),
                                        ),
                                        trailing: Radio(
                                            value: "female",
                                            groupValue: groupValue,
                                            onChanged: (String e) => valueChanged(e)),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  controller: _emailTextController,
                                  decoration: InputDecoration(
                                    hintText: "email".tr(),
                                    icon: const Icon(Icons.alternate_email),
                                      border: InputBorder.none
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern.toString());
                                      if (!regex.hasMatch(value))
                                        return 'email_input_error'.tr();
                                      else
                                        return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    obscureText: hidePass,
                                    controller: _passwordTextController,
                                    decoration: InputDecoration(
                                      hintText: "password".tr(),
                                      icon: const Icon(Icons.lock_outline),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "password_empty_error".tr();
                                      } else if (value.length < 6) {
                                        return "password_long_error".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                      icon: const Icon(Icons.remove_red_eye),
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
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    obscureText: hidePass,
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      hintText: "confirm_password".tr(),
                                      icon: const Icon(Icons.lock_outline),
                                      border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "password_empty_error".tr();
                                      } else if (value.length < 6) {
                                        return "password_long_error".tr();
                                      } else if(_passwordTextController.text != value){
                                        return "confirm_password_error".tr();
                                      }
                                      return null;
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
                                borderRadius: BorderRadius.circular(20.0),
                                color: deepOrange,
                                child: MaterialButton(
                                  onPressed: () async{
                                    validateForm();
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "signin".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )),
                          ),

                         /* Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("Login",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),))
                          ),*/
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "text_have_account".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: deepOrange, fontSize: 16),
                                  ))),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("text_sign_with".tr(), style: const TextStyle(fontSize: 20,color: Colors.grey),),
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
                                        onPressed: () async {
                                          final User firebaseUser = await auth.googleSignIn();
                                          if(firebaseUser!=null){
                                            _userServices.createUser({
                                              "nickname": firebaseUser.displayName,
                                              "email": firebaseUser.email,
                                              "photo": firebaseUser.photoURL,
                                              "id": firebaseUser.uid.toString(),
                                              "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
                                            }, firebaseUser.uid.toString());
                                            changeScreenReplacement(context,HomePage());
                                          }
                                        },
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
              visible: loading ?? true,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.9),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
