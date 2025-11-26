import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/meals_card.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({super.key});

  @override
  State<MyCategoryPage> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  late Future<List<Meal>> mealsFuture;
  final ApiService api = ApiService();

  String categoryName = "";
  String searchQuery = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoryName = ModalRoute.of(context)!.settings.arguments as String;
    mealsFuture = api.loadMeals(categoryName);
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        mealsFuture = api.loadMeals(categoryName);
      } else {
        mealsFuture = api.searchMeals(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search meals...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    performSearch('');
                  },
                )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                performSearch(value);
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final meals = snapshot.data ?? [];

                if (meals.isEmpty) {
                  return const Center(
                    child: Text("No meals found"),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return MealCard(
                      meal: meal,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}