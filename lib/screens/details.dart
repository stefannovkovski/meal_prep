import 'package:flutter/material.dart';
import 'package:meals/models/mealDetails_model.dart';
import 'package:meals/services/api_service.dart';

class MyDetailsPage extends StatelessWidget {
  const MyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? mealId = ModalRoute.of(context)!.settings.arguments as String?;
    final ApiService api = ApiService();

    final Future<MealDetail> mealFuture = mealId == null ? api.getRandomMeal() : api.getMealDetails(mealId);

    return Scaffold(
      appBar: AppBar(
        title: Text(mealId == null ? "Random Meal" : "Meal Details"),
        centerTitle: true,
        actions: [
          if (mealId == null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  "/mealDetails",
                  arguments: null,
                );
              },
            )
        ],
      ),

      body: FutureBuilder<MealDetail>(
        future: mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No meal found'));
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(meal.img,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover),
                const SizedBox(height: 12),

                Text(
                  meal.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Icons.restaurant_menu, size: 18),
                      label: Text(meal.category),
                      backgroundColor: Colors.orange.shade100,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Icon(Icons.public, size: 18),
                      label: Text(meal.area),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (meal.youtubeLink != null &&
                    meal.youtubeLink!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.play_circle_fill,
                          color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          meal.youtubeLink!,
                          style: const TextStyle(color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                const Text('Ingredients:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    meal.ingredients.length,
                        (i) => Text(
                        '- ${meal.measures[i].trim()} ${meal.ingredients[i]}'),
                  ),
                ),

                const SizedBox(height: 16),
                const Text('Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border:
                    Border.all(color: Colors.orange.shade200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    meal.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
