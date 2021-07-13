class CartItemModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const PRICE = "price";
  static const SIZE = "size";
  static const COLOR = "color";
  static const COUNT = "count";

  String _id;
  String _name;
  String _image;
  String _productId;
  String _size;
  String _color;
  int _price;
  int _count;

  //  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  String get productId => _productId;

  String get size => _size;

  String get color => _color;

  int get price => _price;
  int get count => _count;

  //  setters
  set count(int value) {
    assert(_count >= 0);
    _count = value;
  }

  CartItemModel.fromMap(Map data){
    _id = data[ID] as String;
    _name =  data[NAME] as String;
    _image =  data[IMAGE] as String;
    _productId = data[PRODUCT_ID] as String;
    _price = data[PRICE] as int;
    _size = data[SIZE] as String;
    _color = data[COLOR] as String;
    _count = data[COUNT] as int;
  }

  Map toMap() => {
    ID: _id,
    IMAGE: _image,
    NAME: _name,
    PRODUCT_ID: _productId,
    PRICE: _price,
    SIZE: _size,
    COLOR: _color,
    COUNT: _count
  };
}