import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/product.dart';
import 'package:flutter_commerce/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  List<ProductModel> productsFeatured = [];
  Map<String, List<String>> productProperties = [] as Map<String, List<String>>;
  List<String> productPropertiesList = [];

  ProductProvider.initialize() {
    loadProducts();
    loadFeaturedProducts();
  }

  Future<void> loadProducts() async {
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future search({String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }

  Future loadFeaturedProducts({String productName}) async {
    productsFeatured = await _productServices.getFeaturedProducts();
    notifyListeners();
  }

  Future<void> loadProductProperties() async {
    productProperties.clear();
    productPropertiesList.clear();
    for (final product in products) {
      // sizes
      List<String> tempList = [];
      if (productProperties.containsKey("sizes")) {
        tempList = productProperties["sizes"];
      }
      for (final String size in product.sizes) {
        if (!tempList.contains(size)) {
          tempList.add(size);
        }
      }
      tempList.sort();
      productProperties["sizes"] = tempList;

      // colors
      tempList = [];
      if (productProperties.containsKey("colors")) {
        tempList = productProperties["colors"];
      }
      for (final color in product.colors) {
        if (!tempList.contains(color)) {
          tempList.add(color.toString());
        }
      }
      tempList.sort();
      productProperties["colors"] = tempList;
    }
    // properties list
    if (productProperties.containsKey("sizes")) {
      productPropertiesList.add("sizes");
    }
    if (productProperties.containsKey("colors")) {
      productPropertiesList.add("colors");
    }
    notifyListeners();
  }
}
