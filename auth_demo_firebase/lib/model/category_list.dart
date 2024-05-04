// To parse this JSON data, do
//
//     final categoriesList = categoriesListFromJson(jsonString);

import 'dart:convert';

CategoriesList categoriesListFromJson(String str) =>
    CategoriesList.fromJson(json.decode(str));

String categoriesListToJson(CategoriesList data) => json.encode(data.toJson());

class CategoriesList {
  List<StrCategory> meals;

  CategoriesList({
    required this.meals,
  });

  factory CategoriesList.fromJson(Map<String, dynamic> json) => CategoriesList(
        meals: List<StrCategory>.from(
            json["meals"].map((x) => StrCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class StrCategory {
  String strCategory;

  StrCategory({
    required this.strCategory,
  });

  factory StrCategory.fromJson(Map<String, dynamic> json) => StrCategory(
        strCategory: json["strCategory"],
      );

  Map<String, dynamic> toJson() => {
        "strCategory": strCategory,
      };
}
