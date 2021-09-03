import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/product.dart';
import 'package:flutter_commerce/provider/product.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/screens/catalog.dart';
import 'package:flutter_commerce/screens/favorite.dart';
import 'package:flutter_commerce/screens/order.dart';
import 'package:flutter_commerce/screens/profile.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:flutter_commerce/widgets/featured_products.dart';
import 'package:flutter_commerce/widgets/product_card.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ProductServices _productServices = ProductServices();
  @override
  Widget build(BuildContext context) {
    final userProvider =
        context.watch<UserProvider>(); //Provider.of<UserProvider>(context);
    final productProvider = context
        .watch<ProductProvider>(); //Provider.of<ProductProvider>(context);
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/w3.jpeg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/c1.jpg'),
          AssetImage('images/w4.jpeg'),
          AssetImage('images/m2.jpg'),
        ],
        autoplay: false,
        //animationCurve: Curves.fastOutSlowIn,
        //animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: deepOrange),
        elevation: 0.1,
        backgroundColor: white,
        title: Text(
          'app_title'.tr(),
          style: TextStyle(color: deepOrange),
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: deepOrange,
              ),
              onPressed: () {}),
          Stack(children: [
            new IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: deepOrange,
                ),
                onPressed: () {
                  changeScreen(context, CartScreen());
                }),
            userProvider.userModel.cart.length > 0
                ? Badge(
                    //child:
                        //CircleAvatar(radius: 7, backgroundColor: Colors.black),
                    badgeContent: Text(
                      "${userProvider.userModel.cart.length}",
                      style: TextStyle(color: white),
                    ),
                  )
                //Positioned(right: 10, top: 5,
//                  child: CircleAvatar(radius: 7,backgroundColor: Colors.black,child: Text("${userProvider.userModel.cart.length}",style: TextStyle(color: white),)))
                : Container(),
          ])
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
              accountName: CustomText(
                text: userProvider.userModel?.name ?? "username_loading".tr(),
                color: white,
                weight: FontWeight.bold,
                size: 18,
              ),
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "email_loading".tr(),
                color: white,
              ),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red.shade900),
            ),

//            body

            InkWell(
              onTap: () {
                changeScreen(context, HomePage());
              },
              child: ListTile(
                title: Text('home'.tr()),
                leading: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, Profile());
              },
              child: ListTile(
                title: Text('my_account'.tr()),
                leading: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, CatalogScreen());
              },
              child: ListTile(
                title: Text('сatalog'.tr()),
                leading: Icon(
                  Icons.storage,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, OrdersScreen());
              },
              child: ListTile(
                title: Text('my_orders'.tr()),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, CartScreen());
              },
              child: ListTile(
                title: Text('shopping_cart'.tr()),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, FavoriteScreen());
              },
              child: ListTile(
                title: Text('favorites'.tr()),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),

            Divider(),

            InkWell(
              onTap: () {
                userProvider.signOut();
                /*FirebaseAuth.instance.signOut().then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                });*/
              },
              child: ListTile(
                title: Text('log_out').tr(),
                leading: Icon(
                  Icons.transit_enterexit,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            //image carousel begins here
            image_carousel,
/*
            //padding widget
            new Padding(padding: const EdgeInsets.all(4.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: new Text('Categories')),),

            //Horizontal list view be123456@mail.rugins here
            HorizontalList(),

            //padding widget
            new Padding(padding: const EdgeInsets.all(4.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: new Text('Recent products')),),

            //grid view
            Flexible(child: Products()),
*/
            //            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('featured_products').tr()),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('recent_products').tr()),
                ),
              ],
            ),

            Column(
              children: productProvider.products
                  .map((item) => GestureDetector(
                        child: ProductCard(
                          product: item,
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
