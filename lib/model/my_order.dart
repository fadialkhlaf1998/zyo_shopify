import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:zyo_shopify/model/product.dart';

class MyOrder {
  Rx<Product> product;
  Rx<int> quantity;
  Rx<String> price;
  String? size;
  String color;
  int varient_id;

  MyOrder({required this.product,required this.quantity,required this.price,required this.size,required this.color,required this.varient_id});
  factory MyOrder.fromJson(String str) => MyOrder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyOrder.fromMap(Map<String, dynamic> json) => MyOrder(
    product: Product.fromJson(json["product"]).obs,
    quantity: int.parse(json["quantity"].toString()).obs,
    price: json["price"].toString().obs,
    size: json["size"].toString(),
    color: json["color"].toString(),
    varient_id: int.parse(json["varient_id"].toString()),
  );

  Map<String, dynamic> toMap() => {
    "product": product.value,
    "quantity": quantity.value,
    "price": price.value,
    "size":size,
    "color":color,
    "varient_id":varient_id,
  };

}