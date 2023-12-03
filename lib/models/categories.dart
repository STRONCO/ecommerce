class Categories {
  final int? id;
  final String imagen;
  final String texto;

  Categories({this.id, required this.imagen, required this.texto});

  Map<String, dynamic> toMap() {
    return {'id': id, 'imagen': imagen, 'texto': texto};
  }

   Categories.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        imagen = map['imagen'],
        texto = map['texto'];
}
