class Recipe {
  final int id;
  final String title;
  final String? imageUrl;

  Recipe({required this.id, required this.title, this.imageUrl});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['image'] as String?,
    );
  }
}
