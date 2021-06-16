import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commerce/db/order.dart';
import 'package:flutter_commerce/db/users.dart';
import 'package:flutter_commerce/models/cart_item.dart';
import 'package:flutter_commerce/models/favorite_item.dart';
import 'package:flutter_commerce/models/order.dart';
import 'package:flutter_commerce/models/product.dart';
import 'package:flutter_commerce/models/user.dart';
import 'package:uuid/uuid.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;


  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();

  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;

  Status get status => _status;

  User get user => _user;

  // public variables
  List<OrderModel> orders = [];

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async{
        _userModel = await _userServices.getUserById(value.user.uid);
        notifyListeners();
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signUp(String name,String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user) async {
        _userServices.createUser({
          'name':name,
          'email':email,
          'uid':user.user.uid
        }, user.user.uid);
        _userModel = await _userServices.getUserById(user.user.uid);
        notifyListeners();

        /*_firestore.collection('users').doc(user.user.uid).set({
          'name':name,
          'email':email,
          'uid':user.user.uid
        });*/

      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }



  Future<void> _onStateChanged(User user) async{
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart(
      {ProductModel product, String size, String color, int count}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture[0],
        "productId": product.id,
        "price": product.price,
        "size": size,
        "count": count,
        "color": color
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  Future<bool> addToFavourite(
      {ProductModel product}) async {
    try {
      var uuid = Uuid();
      String favouriteItemId = uuid.v4();
      List<FavoriteItemModel> favourite = _userModel.favorite;

      Map favouriteItem = {
        "id": favouriteItemId,
        "name": product.name,
        "productId": product.id,
      };

      FavoriteItemModel item = FavoriteItemModel.fromMap(favouriteItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${favourite.toString()}");
      _userServices.addToFavorite(userId: _user.uid, favouriteItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromFavourite({FavoriteItemModel favouriteItem})async{
    print("THE PRODUC IS: ${favouriteItem.toString()}");

    try{
      _userServices.removeFromFavorite(userId: _user.uid, favouriteItem: favouriteItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  Future<bool> changeCart({CartItemModel cart, int count}) async {
    print("THE PRODUC IS: ${cart.toString()}");

    try{
      removeFromCart(cartItem: cart);
      cart.count = count;
      _userServices.changeCart(userId: _user.uid, cartItem: cart);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}