class ProductsItems {
  int id;
  String title;
  String description;
  String category;
  String image; // Guardaremos la ruta de la imagen
  double price;
  int ranking;
  int calories;
  int additives;
  int vitamins;

  ProductsItems({
   required  this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.ranking,
    required this.calories,
    required this.additives,
    required this.vitamins,
  });

 Map<String, dynamic> toMap({bool excludeId = false}) {
  var map = {
    'title': title,
    'description': description,
    'category': category,
    'image': image,
    'price': price,
    'ranking': ranking,
    'calories': calories,
    'additives': additives,
    'vitamins': vitamins,
  };

  // Exclude 'id' if specified
  if (!excludeId) {
    map['id'] = id;
  }

  return map;
}
  ProductsItems.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        category = map['category'],
        image = map['image'],
        price = map['price'],
        ranking = map['ranking'],
        calories = map['calories'],
        additives = map['additives'],
        vitamins = map['vitamins'];
}
