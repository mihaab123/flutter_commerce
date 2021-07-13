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
    final Map data = snapshot.data() as Map;
    _id = data[ID] as String;
    _brand = data[BRAND] as String;
    _sale = data[SALE] as bool;
    _description = data[DESCRIPTION] as String ?? " ";
    _featured = data[FEATURED] as bool;
    _price = data[PRICE].floor() as int;
    _category = data[CATEGORY] as String;
    _colors = data[COLORS] as List;
    _sizes = data[SIZES] as List;
    _name = data[NAME] as String;
    _picture = data[PICTURE] as List;

  }
}