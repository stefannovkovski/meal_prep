import 'package:flutter/material.dart';
import 'package:meals/screens/details.dart';
import 'package:meals/screens/home.dart';
import 'package:meals/screens/perCategory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App 221012',
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(),
        "/perCategory": (context) => const MyCategoryPage(),
        "/mealDetails": (context) => const MyDetailsPage()
      },
    );
  }
}