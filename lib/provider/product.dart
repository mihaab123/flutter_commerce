
import 'package:flutter/material.dart';
import 'package:flutter_commerce/db/product.dart';
import 'package:flutter_commerce/models/product.dart';

class ProductProvider with ChangeNotifier{
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  List<ProductModel> productsFeatured = [];
  Map<String,List<String>> productProperties = Map<String,List<String>>();
  List<String> productPropertiesList =List<String>();


  ProductProvider.initialize(){
    loadProducts();
    loadFeaturedProducts();
  }

  loadProducts()async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future search({String productName})async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
  Future loadFeaturedProducts({String productName})async{
    productsFeatured = await _productServices.getFeaturedProducts();
    notifyListeners();
  }
  loadProductProperties()async{
    productProperties.clear();
    productPropertiesList.clear();
    for (var product in products){
      // sizes
      List<String> tempList = [];
      if(productProperties.containsKey("sizes")){
        tempList = productProperties["sizes"];
      }
      for (var size in product.sizes) {
        if (!tempList.contains(size)) {
          tempList.add(size);
        }
      }
      tempList.sort();
      productProperties["sizes"] = tempList;

      // colors
      tempList = [];
      if(productProperties.containsKey("colors")){
        tempList = productProperties["colors"];
      }
      for (var color in product.colors) {
        if (!tempList.contains(color)) {
          tempList.add(color);
        }
      }
      tempList.sort();
      productProperties["colors"] = tempList;
    }
    // properties list
    if(productProperties.containsKey("sizes")) {
      productPropertiesList.add("sizes");
    }
    if(productProperties.containsKey("colors")) {
      productPropertiesList.add("colors");
    }
    notifyListeners();
  }

}