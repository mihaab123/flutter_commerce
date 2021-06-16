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
    Map data = snapshot.data();
    _id = data[ID];
    _description = data[DESCRIPTION];
    _total = data[TOTAL];
    _status = data[STATUS];
    _userId = data[USER_ID];
    _createdAt = data[CREATED_AT];
    cart = data[CART];
  }
}