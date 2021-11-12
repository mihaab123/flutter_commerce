import 'package:flutter/material.dart';
import 'package:flutter_commerce/models/product.dart';
import 'package:flutter_commerce/widgets/common.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback press;
  const CatalogItem({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              //padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: product.id,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: product.picture[0] as String,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20 / 4),
            child: Text(
              // products is out demo list
              product.name,
              style: TextStyle(color: black),
            ),
          ),
          Text(
            "\$${product.price / 100}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
