import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const QUANTITY = "quantity";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const SIZES = "sizes";
  static const COLORS = "colors";

  String _id;
  String _name;
  List _picture;
  String _description;
  String _category;
  String _brand;
  int _quantity;
  int _price;
  bool _sale;
  bool _featured;
  List _colors;
  List _sizes;

  String get id => _id;

  String get name => _name;

  List get picture => _picture;

  String get brand => _brand;

  String get category => _category;

  String get description => _description;

  int get quantity => _quantity;

  int get price => _price;

  bool get featured => _featured;

  bool get sale => _sale;

  List get colors => _colors;

  List get sizes => _sizes;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    _id = data[ID];
    _brand = data[BRAND];
    _sale = data[SALE];
    _description = data[DESCRIPTION] ?? " ";
    _featured = data[FEATURED];
    _price = data[PRICE].floor();
    _category = data[CATEGORY];
    _colors = data[COLORS];
    _sizes = data[SIZES];
    _name = data[NAME];
    _picture = data[PICTURE];

  }
}