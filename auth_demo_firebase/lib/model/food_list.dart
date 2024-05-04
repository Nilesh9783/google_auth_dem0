// To parse this JSON data, do
//
//     final foodList = foodListFromJson(jsonString);

import 'dart:convert';

FoodList foodListFromJson(String str) => FoodList.fromJson(json.decode(str));

String foodListToJson(FoodList data) => json.encode(data.toJson());

class FoodList {
  List<Food> meals;

  FoodList({
    required this.meals,
  });

  factory FoodList.fromJson(Map<String, dynamic> json) => FoodList(
        meals: List<Food>.from(json["meals"].map((x) => Food.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class Food {
  String? strMeal;
  String? strMealThumb;
  String? idMeal;
  num price = 100;
  num calorise = 5;
  int numCount = 0;

  Food({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        strMeal: json["strMeal"],
        strMealThumb: json["strMealThumb"],
        idMeal: json["idMeal"],
      );

  Map<String, dynamic> toJson() => {
        "strMeal": strMeal,
        "strMealThumb": strMealThumb,
        "idMeal": idMeal,
      };
}
