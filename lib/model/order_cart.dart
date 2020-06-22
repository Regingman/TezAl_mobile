class OrderCart {
  int id;
  double count;
  double sum;
  double rawMaterialVolume;
  String rawMaterialName;

  OrderCart.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rawMaterialVolume = json['rawMaterialVolume'],
        rawMaterialName = json['rawMaterialName'],
        count = json['count'],
        sum = json['sum'];

  OrderCart(
      {this.id,
      this.count,
      this.sum,
      this.rawMaterialName,
      this.rawMaterialVolume});
}
