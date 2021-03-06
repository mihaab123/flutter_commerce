import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "my_account".tr()),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Image(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1470104240373-bc1812eddc9f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb'),
              ),
              Positioned(
                bottom: -60.0,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                /*  backgroundImage: NetworkImage(
                      userProvider.user?.photoURL),**/
                  child: Icon(Icons.person, color: black,),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          ListTile(
            title: Center(
                child: CustomText(
                  text: userProvider.userModel?.name,
                  color: black,
                  weight: FontWeight.bold,
                  size: 18,
                ),
            ),
            subtitle: Center(child: CustomText(
              text: userProvider.userModel?.email,
              color: Colors.grey,
              weight: FontWeight.bold,
              size: 18,
            ),
            ),
          ),
          FlatButton.icon(
            onPressed: () {
              _showChangePassDialog(userProvider.user);
            },
            icon: Icon(
              Icons.security,
              color: Colors.white,
            ),
            label: Text(
              'change_password'.tr(),
              style: TextStyle(color: Colors.white),
            ),
            color: deepOrange,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePassDialog(User user) async {
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _newPasswordTextController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('change_password').tr(),
        content: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  controller: _passwordTextController,
                  decoration: InputDecoration(
                      hintText: "old_password".tr(),
                      icon: Icon(Icons.lock_outline),
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
                TextFormField(
                  obscureText: true,
                  controller: _newPasswordTextController,
                  decoration: InputDecoration(
                      hintText: "new_password".tr(),
                      icon: Icon(Icons.lock_outline),
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
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      hintText: "confirm_password".tr(),
                      icon: Icon(Icons.lock_outline),
                      border: InputBorder.none
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "password_empty_error".tr();
                    } else if (value.length < 6) {
                      return "password_long_error".tr();
                    } else if(_newPasswordTextController.text != value){
                      return "confirm_password_error".tr();
                    }
                    return null;
                  },
                )
              ],
            ),

          ),
        ),
        actions: [
          FlatButton(
            child: Text('exit').tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('ok').tr(),
            onPressed: () {
              if(_formKey.currentState.validate()){
                AuthCredential authCredential = EmailAuthProvider.credential(
                  email: user.email,
                  password: _passwordTextController.text,
                );
                user.reauthenticateWithCredential(authCredential).then((result) {
                  user.updatePassword(_newPasswordTextController.text).then((_){
                    print("Successfully changed password");
                    Navigator.of(context).pop();
                  }).catchError((error){
                    print("Password can't be changed" + error.toString());
                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                  });
                }).catchError((error) {
                  print("Error: $error");
                });
              }
            },
          ),
        ],
      );
    });
  }
}
