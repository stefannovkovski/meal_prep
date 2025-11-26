class Meal{
  String id;
  String img;
  String mealName;

  Meal({
    required this.id,
    required this.img,
    required this.mealName});

  Meal.fromJson(Map<String,dynamic> data)
  : id = data['idMeal'],
  img = data['strMealThumb'],
  mealName = data['strMeal'];
}