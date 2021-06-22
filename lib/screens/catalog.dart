import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/product.dart';
import 'package:flutter_commerce/provider/product.dart';
import 'package:flutter_commerce/provider/user_provider.dart';
import 'package:flutter_commerce/screens/product_details.dart';
import 'package:flutter_commerce/screens/profile.dart';
import 'package:flutter_commerce/widgets/applied_filters.dart';
import 'package:flutter_commerce/widgets/catalog_items.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:flutter_commerce/widgets/custom_text.dart';
import 'package:flutter_commerce/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;

import 'cart.dart';
import 'favorite.dart';
import 'home.dart';
import 'order.dart';

class CatalogScreen extends StatefulWidget {
  final Map<String, String> usedFilters = Map<String, String>();
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.loadProductProperties();
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: deepOrange),
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: deepOrange,
          ),
          onPressed: () {
            changeScreen(context, HomePage());
          },
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: deepOrange,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: deepOrange,
              ),
              onPressed: () {
                changeScreen(context, CartScreen());
              })
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Text("text_filter_by").tr(),
            Expanded(
              child: ExpandableTheme(
                data: const ExpandableThemeData(
                  iconColor: Colors.lightBlue,
                  useInkWell: true,
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: productProvider.productPropertiesList.length,
                  itemBuilder: (_, index) {
                    return Card3(
                        productProvider.productProperties[
                            productProvider.productPropertiesList[index]],
                        productProvider.productPropertiesList[index], productProvider);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("button_apply").tr(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppliedFilters(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  itemCount: productProvider.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => CatalogItem(
                        product: productProvider.products[index],
                        press: () => changeScreen(
                            context,
                            ProductDetails(
                              product: productProvider.products[index],
                            )),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}

class Card3 extends StatelessWidget {
  List<String> valueList;
  String valueName;
  var productProvider;
  Card3(List<String> productPropertiesList, String productPropertiesName, var productProvider1) {
    valueList = productPropertiesList;
    valueName = productPropertiesName;
    productProvider = productProvider1;
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: CheckboxListTile(
          title: Text(label),
          onChanged: (bool value) {},
          value: checkPropertyFilter(label,valueName),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in valueList) buildItem("${i}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            valueName,
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: buildList(), collapsed: null,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  bool checkPropertyFilter(String label, String propertyName) {
    return false;//if(widget.usedFilters.)
  }
}
