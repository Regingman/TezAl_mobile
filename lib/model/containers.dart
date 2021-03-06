class Containers {
  int id;
  String name;
  int budgetId;
  int containerCategoryId;
  int number;
  String image;

  Containers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    budgetId = json['budgetId'];
    containerCategoryId = json['containerCategoryId'];
    number = json['number'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'budgetId': budgetId,
        'containerCategoryId': containerCategoryId,
        'number': number,
      };

  Containers(
      {this.id,
      this.name,
      this.budgetId,
      this.containerCategoryId,
      this.number});
}
