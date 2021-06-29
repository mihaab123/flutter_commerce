import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/liqpay_checkout.dart';

import 'package:flutter_commerce/db/order.dart';
import 'package:flutter_commerce/db/payment.dart';
import 'package:flutter_commerce/models/cart_item.dart';
import 'package:flutter_commerce/provider/app.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/screens/product_details.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:flutter_commerce/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = "sk_test_51J3MCWHQdn1qugM7Rmr6UPWhwkFHq2mOJj9oxiEZ1BsYF9MSSNFOPPq4U4EDnGer3Ks8It8eq8JTWqGP9uguSnUd00ZZ58TB8F"; //set this yourself, e.g using curl  // TODO: implement initState
  PaymentIntentResult _paymentIntent;



   @override
   void initState() {
    super.initState();
   Source _source;  StripePayment.setOptions(
      StripeOptions(
          publishableKey: "pk_test_51J3MCWHQdn1qugM72L5bSB8YDZl0ZtJxTYVzNMktLZum5q91yLFx45w1iAaUBifroVZf06G3UjaoSnKI0y6MK9iN00kIZ1WFjX",
          merchantId: "YOUR_MERCHANT_ID" ,
          androidPayMode: 'test' )
      );
  }



  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "shopping_cart".tr()),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
          itemCount: userProvider.userModel.cart.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                //onTap: () {changeScreen(context, ProductDetails(product: product,));},
                onLongPress: () async {
                  appProvider.changeIsLoading();
                  bool success =
                  await userProvider.removeFromCart(
                      cartItem: userProvider
                          .userModel.cart[index]);
                  if (success) {
                    userProvider.reloadUserModel();
                    print("Item added to cart");
                    _key.currentState.showSnackBar(SnackBar(
                        content: Text("button_remove_cart").tr()));
                    appProvider.changeIsLoading();
                    return;
                  } else {
                    appProvider.changeIsLoading();
                  }
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red.withOpacity(0.2),
                            offset: Offset(3, 2),
                            blurRadius: 30)
                      ]),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        child: Image.network(
                          userProvider.userModel.cart[index].image,
                          height: 120,
                          width: 140,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: userProvider
                                        .userModel.cart[index].name +
                                        "\n",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: userProvider
                                        .userModel.cart[index].size + ", "+userProvider
                                        .userModel.cart[index].color +
                                        "\n",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)),

                                TextSpan(
                                    text:
                                    "\$${userProvider.userModel.cart[index].price / 100} \n",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)),

                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.all(4.0),
                              child: SpinnerInput(
                                spinnerValue: userProvider.userModel.cart[index].count.toDouble(),
                                minValue: 1,
                                onChange: (newValue) async {
                                  bool success = await userProvider.changeCart(
                                      cart: userProvider.userModel.cart[index],
                                      count: newValue.toInt());
                                  await userProvider.reloadUserModel();
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            /*IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  appProvider.changeIsLoading();
                                  bool success =
                                  await userProvider.removeFromCart(
                                      cartItem: userProvider
                                          .userModel.cart[index]);
                                  if (success) {
                                    userProvider.reloadUserModel();
                                    print("Item added to cart");
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text("Removed from Cart!")));
                                    appProvider.changeIsLoading();
                                    return;
                                  } else {
                                    appProvider.changeIsLoading();
                                  }
                                })*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "text_total".tr(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${userProvider.userModel.totalCartPrice / 100}",
                      style: TextStyle(
                          color: black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: black),
                child: FlatButton(
                    onPressed: () {
                      if (userProvider.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'text_empty_cart'.tr(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Payment();
                           /* return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You will be charged \$${userProvider.userModel.totalCartPrice / 100} upon delivery!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
                                            .then((paymentMethod){
                                              setState(() {
                                                _paymentMethod = paymentMethod;
                                              });
                                            });
                                           /* LiqpayCheckout liqpayCheckout = LiqpayCheckout(3, "sandbox_i37399360418", "pay", 10, "UAH", "description", "0000001");
                                            String json_string = jsonEncode(liqpayCheckout.toJson());
                                            String data = base64Encode(utf8.encode(json_string));
                                            String private_key = "sandbox_LVbZgjcZpJDgcIrzseaSAReAXojy4sxLqgjiSFEW";
                                            String sign_string = private_key + data + private_key;
                                            String signature  = base64Encode(sha1.convert(sign_string.codeUnits).bytes);
                                            final response = await http.post(
                                                Uri.parse('https://www.liqpay.ua/api/3/checkout'),
                                                //Uri.parse('https://www.liqpay.ua/api/request'),
                                                headers: <String, String>{
                                                  'Content-Type': 'application/x-www-form-urlencoded',
                                                  'signature': signature,
                                                },
                                                body: data,
                                            );
                                            print(response.statusCode);      */
                                            /*var uuid = Uuid();
                                            String id = uuid.v4();
                                            _orderServices.createOrder(
                                                userId: userProvider.user.uid,
                                                id: id,
                                                description:
                                                "Some random description",
                                                status: "complete",
                                                totalPrice: userProvider
                                                    .userModel.totalCartPrice,
                                                cart: userProvider
                                                    .userModel.cart);
                                            for (CartItemModel cartItem
                                            in userProvider
                                                .userModel.cart) {
                                              bool value = await userProvider
                                                  .removeFromCart(
                                                  cartItem: cartItem);
                                              if (value) {
                                                userProvider.reloadUserModel();
                                                print("Item added to cart");
                                                _key.currentState.showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Removed from Cart!")));
                                              } else {
                                                print("ITEM WAS NOT REMOVED");
                                              }
                                            }
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Order created!")));
                                            Navigator.pop(context);*/
                                          },
                                          child: Text(
                                            "Accept",
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                          color: const Color(0xFF1BC0C5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ); */
                          });
                    },
                    child: CustomText(
                      text: "text_cart_checkout".tr(),
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}