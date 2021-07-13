class FavoriteItemModel {
  static const ID = "id";
  static const PRODUCT_ID = "productId";

  String _id;
  String _productId;

  //  getters
  String get id => _id;

  String get productId => _productId;


  FavoriteItemModel.fromMap(Map data){
    _id = data[ID] as String;
    _productId = data[PRODUCT_ID] as String;
  }

  Map toMap() => {
    ID: _id,
    PRODUCT_ID: _productId,
  };
}