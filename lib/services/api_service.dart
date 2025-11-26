import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/mealDetails_model.dart';
import '../models/meal_model.dart';

class ApiService {
  Future<List<CategoryMeal>> loadCategories() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> categoriesJson = data['categories'] ?? [];
      final List<CategoryMeal> categories = categoriesJson
          .map((json) => CategoryMeal.fromJson(json))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> loadMeals(String category) async{
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${category}')
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final List<dynamic> mealsJson = data['meals'] ?? [];
      final List<Meal> meals = mealsJson
          .map((json) => Meal.fromJson(json))
          .toList();
      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query')
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> mealsJson = data['meals'] ?? [];
      final List<Meal> meals = mealsJson
          .map((json) => Meal.fromJson(json))
          .toList();
      return meals;
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail> getMealDetails(String mealId) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId')
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealJson = data['meals'][0];
      return MealDetail.fromJson(mealJson);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<MealDetail> getRandomMeal() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php')
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealJson = data['meals'][0];
      return MealDetail.fromJson(mealJson);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
