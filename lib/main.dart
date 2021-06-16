import 'package:flutter/material.dart';
import 'package:flutter_commerce/provider/app.dart';
import 'package:flutter_commerce/provider/product.dart';

import 'package:flutter_commerce/screens/home.dart';
import 'package:flutter_commerce/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPaintSizeEnabled = false;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductProvider.initialize()),
    ChangeNotifierProvider.value(value: AppProvider()),
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
            primaryColor: Colors.deepOrange
        ),
        home: ScreensController(),
      )));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Login();//Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default: return Login();
    }
  }
}

