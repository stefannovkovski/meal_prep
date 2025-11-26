class CategoryMeal{
  String id;
  String category;
  String img;
  String description;

  CategoryMeal({
    required this.id,
    required this.category,
    required this.img,
    required this.description
  });

  CategoryMeal.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'],
        category = data['strCategory'],
        img = data['strCategoryThumb'],
        description = data ['strCategoryDescription'];
}