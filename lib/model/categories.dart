import 'dart:convert';

class Categories {
  Categories({
    this.categories
  });

  List<Category>? categories;

  factory Categories.fromJson(String str) => Categories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories!.map((x) => x.toMap())),
  };
}

class Category {
  Category({
    this.id,
    this.title,
    this.image
  });

  int? id;
  String? title;
  String? image;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String,dynamic> json) => Category(
      id: json["id"],
      title: json["title"],
      image: json["image"]
  );

  Map<String,dynamic> toMap() =>{
    "id": id,
    "title": title,
    "image": image
  };

}

