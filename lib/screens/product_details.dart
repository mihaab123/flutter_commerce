import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commerce/models/favorite_item.dart';

import 'package:flutter_commerce/models/product.dart';
import 'package:flutter_commerce/provider/app.dart';
import 'package:flutter_commerce/provider/user_provider.dart';

import 'package:flutter_commerce/widgets/common.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:flutter_commerce/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'cart.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _color = "";
  String _size = "";
  FavoriteItemModel _favorite;
  final _pageController = PageController(viewportFraction: 0.877);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = widget.product.colors[0];
    _size = widget.product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    _favorite = getFavourite(userProvider);
    return Scaffold(
      key: _key,
      body: SafeArea(
          child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                /*Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: Loading(),
                )),*/
                Center(
                    child: Container(
                      height: 400,
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          widget.product.picture.length,
                                (index) =>
                                  Container(
                                    margin: EdgeInsets.only(right: 28.8),
                                    width: MediaQuery.of(context).size.width,
                                    height: 400,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9.6),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                widget.product.picture[index]),
                                            fit: BoxFit.fill)),
                                  )
                        ),
                      ),
                    ),

                  /*child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.product.picture[0],
                    fit: BoxFit.fill,
                    height: 400,
                    width: double.infinity,
                  ),*/
                ),
                Positioned(
                  top: 30,
                  left: 180,
                  child:SmoothPageIndicator(
                    count: widget.product.picture.length,
                    controller: _pageController,
                    effect: ExpandingDotsEffect(
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey.shade600,
                        dotHeight: 4.8,
                        dotWidth: 6,
                        spacing: 4.8
                    ),
                  ),
                ),
               /* Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.07),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container())),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.07),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container())),
                ),*/
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.product.name,
                              style: TextStyle(
                                  color: red,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '\$${widget.product.price / 100}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: red,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        changeScreen(context, CartScreen());
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_cart),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  right: 45,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () async {
                        appProvider.changeIsLoading();
                        bool success =false;
                        if(_favorite!=null){
                          success= await userProvider.removeFromFavourite(favouriteItem: _favorite);
                        }else{
                          success = await userProvider.addToFavourite(product: widget.product);
                        }
                        if (success) {
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("text_add_favorite").tr()));
                          userProvider.reloadUserModel();
                          appProvider.changeIsLoading();
                          return;
                        } else {
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("text_no_add_favorite").tr()));
                          appProvider.changeIsLoading();
                          return;
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(_favorite!=null?Icons.favorite:Icons.favorite_border),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        print("CLICKED");
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(35))),
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(2, 5),
                          blurRadius: 10)
                    ]),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomText(
                        text: "text_select_color".tr(),
                        color: white,
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.colors.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color:
                                          widget.product.colors[index] == _color
                                              ? Colors.red
                                              : Colors.black,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _color = widget.product.colors[index];
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: getColorProduct(index),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomText(
                        text: "text_select_size".tr(),
                        color: white,
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.sizes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: InkWell(
                                  child: CustomText(
                                    text: widget.product.sizes[index],
                                    color: widget.product.sizes[index] == _size
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _size = widget.product.sizes[index];
                                    });
                                  },
                                ),
                              );
                            })),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Description:\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s  Lorem Ipsum has been the industry standard dummy text ever since the 1500s ',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool success = await userProvider.addToCart(
                                  product: widget.product,
                                  color: _color,
                                  size: _size,
                                  count: 1);
                              if (success) {
                                _key.currentState.showSnackBar(
                                    SnackBar(content: Text("text_add_cart").tr()));
                                userProvider.reloadUserModel();
                                appProvider.changeIsLoading();
                                return;
                              } else {
                                _key.currentState.showSnackBar(SnackBar(
                                    content: Text("text_no_add_cart").tr()));
                                appProvider.changeIsLoading();
                                return;
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: appProvider.isLoading
                                ? Loading()
                                : Text(
                                    "text_add_to_cart".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Color getColorProduct(int index) {
    return colorList[widget.product.colors[index]];
  }
  FavoriteItemModel getFavourite(UserProvider userProvider){
    for (var pair in userProvider.userModel.favorite){
      if(pair.productId == widget.product.id){
        return pair;
      }
    }
    return null;
  }
}
