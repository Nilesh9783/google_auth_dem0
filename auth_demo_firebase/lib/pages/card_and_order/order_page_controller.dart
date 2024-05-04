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
}
