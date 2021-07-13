import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String _id;
  String _description;
  String _userId;
  String _status;
  int _createdAt;
  int _total;

//  getters
  String get id => _id;

  String get description => _description;

  String get userId => _userId;

  String get status => _status;

  int get total => _total;

  int get createdAt => _createdAt;

  // public variable
  List cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map data = snapshot.data() as Map;
    _id = data[ID] as String;
    _description = data[DESCRIPTION] as String;
    _total = data[TOTAL] as int;
    _status = data[STATUS] as String;
    _userId = data[USER_ID] as String;
    _createdAt = data[CREATED_AT] as int;
    cart = data[CART] as List;
  }
}