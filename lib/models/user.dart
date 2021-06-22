import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_commerce/models/favorite_item.dart';

import 'cart_item.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "nickname";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const FAVORITE = "favourite";


  String _name;
  String _email;
  String _id;
  String _stripeId;
  int _priceSum = 0;


//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get stripeId => _stripeId;

  // public variables
  List<CartItemModel> cart;
  List<FavoriteItemModel> favorite;
  int totalCartPrice;



  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    _name = data[NAME];
    _email = data[EMAIL];
    _id = data[ID];
    _stripeId = data[STRIPE_ID] ?? "";
    cart = _convertCartItems(data[CART]?? []);
    favorite = _convertFavoriteItems(data[FAVORITE]?? []);
    totalCartPrice = data[CART] == null ? 0 :getTotalPrice(cart: data[CART]);

  }

  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  List<FavoriteItemModel> _convertFavoriteItems(List favorite){
    List<FavoriteItemModel> convertedCart = [];
    for(Map favoriteItem in favorite){
      convertedCart.add(FavoriteItemModel.fromMap(favoriteItem));
    }
    return convertedCart;
  }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"] * cartItem["count"];
    }

    int total = _priceSum;
    return total;
  }
}