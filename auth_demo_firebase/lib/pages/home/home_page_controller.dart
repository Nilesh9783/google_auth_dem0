import 'package:auth_demo_firebase/main.dart';
import 'package:auth_demo_firebase/model/category_list.dart';
import 'package:auth_demo_firebase/model/food_list.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:auth_demo_firebase/utils/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageContoller extends GetxController {
  var categoriesList = <StrCategory>[].obs;
  var foodList = <Food>[].obs;
  var isLoading = false.obs;
  var totalCartCount = 0.obs;
  FoodList? foodRespModel;

  String strCat = 'Seafood';

  // Observable list of tab titles
  var tabTitles = <String>[].obs;

  @override
  void onInit() {
    basedOngetMeals();
    super.onInit();
  }

  // Function to update tab titles
  void updateTabTitles(List<String> titles) {
    tabTitles.assignAll(titles);
  }

  Future<void> getCategory() async {
    try {
      isLoading.value = true;
      await sl
          .get<APIServices>()
          .getApiCall(ApiConstant.catListApi)
          .then((value) {
        CategoriesList categoriesListModel = categoriesListFromJson(value.data);
        categoriesList.addAll(categoriesListModel.meals);
        List<String> nameCate = [];
        for (var element in categoriesListModel.meals) {
          nameCate.add(element.strCategory);
        }
        updateTabTitles(nameCate);
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  Future<void> basedOngetMeals() async {
    try {
      isLoading.value = true;
      await sl.get<APIServices>().getAPICallWithQueryParam(
          ApiConstant.foodListApi, {'c': strCat}).then((value) {
        foodRespModel = foodListFromJson(value.data);
        foodList.addAll(foodRespModel?.meals ?? []);
        isLoading.value = false;
        update();
      });
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  incrementDecrementCounter(
      {required Food food, required int index, required bool isAdd}) {
    int count = food.numCount;

    if (isAdd) {
      totalCartCount++;
      count = (count + 1);
    } else {
      totalCartCount--;
      count = (count != 0) ? (count - 1) : 0;
    }
    food.numCount = count;
    List<Food> tempList = foodList.value;
    tempList[index] = food;
    foodList.value = tempList;
    update();
  }

  List<Food> getSelectedFood() {
    List<Food> selected = [];
    for (var element in foodList) {
      if (element.numCount > 0) {
        selected.add(element);
      }
    }
    return selected;
  }

  void clearAllData() {
    for (var element in foodList) {
      element.numCount = 0;
    }
    totalCartCount.value = 0;
    update();
  }
}
