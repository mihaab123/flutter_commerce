import 'package:flutter/material.dart';

import 'package:flutter_commerce/db/order.dart';
import 'package:flutter_commerce/models/cart_item.dart';
import 'package:flutter_commerce/models/product.dart';
import 'package:flutter_commerce/provider/app.dart';
import 'package:flutter_commerce/provider/product.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:flutter_commerce/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:uuid/uuid.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> cartList = getFavoriteCartItem(userProvider,productProvider);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "favorites".tr()),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
          itemCount: cartList.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          offset: const Offset(3, 2),
                          blurRadius: 30)
                    ]),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: Image.network(
                        cartList[index].picture[0] as String,
                        height: 120,
                        width: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "${cartList[index].name}\n",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),

                              TextSpan(
                                  text:
                                  "\$${cartList[index].price / 100} \n",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300)),

                            ]),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                appProvider.changeIsLoading();
                                final bool success =
                                await userProvider.removeFromFavourite(
                                    favouriteItem: userProvider
                                        .userModel.favorite[index]);
                                if (success) {
                                  userProvider.reloadUserModel();
                                  debugPrint("Item removed for favorite");
                                  _key.currentState.showSnackBar(SnackBar(
                                      content: const Text("button_remove_favorite").tr()));
                                  appProvider.changeIsLoading();
                                  return;
                                } else {
                                  appProvider.changeIsLoading();
                                }
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<ProductModel> getFavoriteCartItem(UserProvider userProvider, ProductProvider productProvider) {
    List<ProductModel> list=[];
    for (final pairFavorite in userProvider.userModel.favorite){
      for (final pairProduct in productProvider.products){
          if(pairFavorite.productId == pairProduct.id){
            list.add(pairProduct);
          };
      };
    };
    return list;
  }
}