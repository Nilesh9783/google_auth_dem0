import 'package:auth_demo_firebase/model/food_list.dart';
import 'package:get/get.dart';

class OrderPageController extends GetxController {
  List<Food> listFood = <Food>[].obs;
  var totalCartCount = 0.obs;
  setUpListFoodData(
      {required List<Food> homePageData, required RxInt cartCount}) {
    listFood = homePageData;
    totalCartCount.value = cartCount.value;
    update();
  }

  getTotalAmount() {
    num amount = 0;
    for (var element in listFood) {
      if (element.price > 0) {
        amount = amount + element.price * element.numCount;
      }
    }
    return amount;
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
    List<Food> tempList = listFood;
    tempList[index] = food;
    listFood = tempList;
    update();
  }
}
