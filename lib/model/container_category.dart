class ContainerCategory {
  int id;
  String name;

  ContainerCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  ContainerCategory({this.id, this.name});
}
