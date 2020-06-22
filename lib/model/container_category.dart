class ContainerCategory {
  int id;
  String name;
  String image;

  ContainerCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  ContainerCategory({this.id, this.name, this.image});
}
