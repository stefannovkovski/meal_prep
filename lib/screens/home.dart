import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<CategoryMeal>> categoriesFuture;
  final ApiService api = ApiService();

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    categoriesFuture = api.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories    221012"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/mealDetails",
                  arguments: null,
                );
              },
              child: const Text(
                "Random Meal",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<CategoryMeal>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data ?? [];
          final filteredCategories = categories.where((cat) {
            return cat.category.toLowerCase().contains(searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search categories...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final c = filteredCategories[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/perCategory",
                          arguments: c.category,
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(c.img, width: 100),
                          title: Text(c.category),
                          subtitle: Text(
                            c.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
