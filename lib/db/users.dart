
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_commerce/models/cart_item.dart';
import 'package:flutter_commerce/models/favorite_item.dart';
import 'package:flutter_commerce/models/user.dart';

class UserServices{
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  String ref = "users";

  void createUser(Map<String,dynamic> value, String id){
    _database.collection(ref).doc(id).set(value)
        .catchError((e) => {
      debugPrint(e.toString())
    });
  }
  Future<UserModel> getUserById(String id)=> _database.collection(ref).doc(id).get().then((doc){
    print("==========id is $id=============");
    /*debugPrint("==========NAME is ${doc.data()['nickname']}=============");
    debugPrint("==========NAME is ${doc.data()['nickname']}=============");
    debugPrint("==========NAME is ${doc.data()['nickname']}=============");
    debugPrint("==========NAME is ${doc.data()['nickname']}=============");

    print("==========NAME is ${doc.data()['nickname']}=============");
    print("==========NAME is ${doc.data()['nickname']}=============");
    print("==========NAME is ${doc.data()['nickname']}=============");*/


    return UserModel.fromSnapshot(doc);
  });

  void addToCart({String userId, CartItemModel cartItem}){
    _database.collection(ref).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void removeFromCart({String userId, CartItemModel cartItem}){
    _database.collection(ref).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }

  void addToFavorite({String userId, FavoriteItemModel favouriteItem}){
    _database.collection(ref).doc(userId).update({
      "favourite": FieldValue.arrayUnion([favouriteItem.toMap()])
    });
  }

  void removeFromFavorite({String userId, FavoriteItemModel favouriteItem}){
    _database.collection(ref).doc(userId).update({
      "favourite": FieldValue.arrayRemove([favouriteItem.toMap()])
    });
  }

  void changeCart({String userId, CartItemModel cartItem}) {
    _database.collection(ref).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }
}