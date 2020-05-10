import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class RawMaterial {
  int id;
  String name;
  String category;
  double wholesalePrice;
  double retailPrice;
  double quantityInStock;

  int rawMaterialId;
  int count = 1;
  double summ = 0;

  // Image image = "";

  RawMaterial.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['rawMaterialName'],
        category = json['rawMaterialCategory'],
        retailPrice = json['retailPrice'],
        quantityInStock = json['quantityInStock'],
        rawMaterialId = json['rawMaterialId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  RawMaterial(
      {this.id,
      this.name,
      this.category,
      this.retailPrice,
      this.quantityInStock,
      this.rawMaterialId,
      this.wholesalePrice});
}
