class MealDetail {
  String id;
  String name;
  String category;
  String area;
  String instructions;
  String img;
  String? youtubeLink;
  List<String> ingredients;
  List<String> measures;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.img,
    this.youtubeLink,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetail.fromJson(Map<String, dynamic> data) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String? ingredient = data['strIngredient$i'];
      String? measure = data['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return MealDetail(
      id: data['idMeal'],
      name: data['strMeal'],
      category: data['strCategory'] ?? '',
      area: data['strArea'] ?? '',
      instructions: data['strInstructions'] ?? '',
      img: data['strMealThumb'],
      youtubeLink: data['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}