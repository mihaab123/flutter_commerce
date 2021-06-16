import 'package:flutter/material.dart';

Color deepOrange = Colors.deepOrange;
Color black = Colors.black;
Color white = Colors.white;
Color red = Colors.red;
Color blue = Colors.blue;
Color green = Colors.green;
Color yellow = Colors.yellow;
Map<String,Color> colorList = {'deepOrange': deepOrange,
  'black': black,
  'red': red,
  'blue': blue,
  'green': green,
  'yellow': yellow,
  'white': white};

// methods
void changeScreen(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void changeScreenReplacement(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
}