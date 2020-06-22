class Order {
  int id;
  String ordersStatus;
  int userId;
  int clientId;
  int organizationId;
  String organizationName;
  DateTime updatedDate;

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        ordersStatus = json['ordersStatus'],
        userId = json['userId'] as int,
        clientId = json['clientId'] as int,
        organizationId = json['organizationId'] as int,
        organizationName = json['organizationName'];

  Order(
      {this.clientId,
      this.ordersStatus,
      this.organizationId,
      this.organizationName,
      this.updatedDate,
      this.userId});
}
