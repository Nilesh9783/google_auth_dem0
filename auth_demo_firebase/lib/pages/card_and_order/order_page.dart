import 'package:auth_demo_firebase/model/food_list.dart';
import 'package:auth_demo_firebase/pages/card_and_order/order_page_controller.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  OrderPageController orderPageController = Get.put(OrderPageController());
  @override
  void initState() {
    // TODO: implement initState
    var arguments = Get.arguments;
    var value = arguments[ArgumentKey.selectedFoodList];
    var totalCarCount = arguments[ArgumentKey.totalcartCount];
    orderPageController.setUpListFoodData(
        homePageData: value, cartCount: totalCarCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        title: Text(StringConstant.orderSummray),
      ),
      body: Obx(
        () => Card(
          margin: const EdgeInsets.all(16),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        height: 48,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(1, 69, 4, 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '${orderPageController.listFood.length} Dishes - ${orderPageController.totalCartCount} items',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                GetBuilder<OrderPageController>(
                    init: OrderPageController(),
                    builder: (controller) {
                      return Container(
                        height: (orderPageController.listFood.length == 1)
                            ? MediaQuery.of(context).size.height * 0.3
                            : (orderPageController.listFood.length == 2)
                                ? MediaQuery.of(context).size.height * 0.45
                                : MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                            itemCount: orderPageController.listFood.length,
                            itemBuilder: (_, int index) {
                              return productTile(
                                  food: orderPageController.listFood[index],
                                  index: index);
                            }),
                      );
                    }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstant.totalAmount,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Text(
                        'INR ${orderPageController.getTotalAmount()}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: placeOrderButton(),
    );
  }

  Widget productTile({required Food food, required int index}) {
    Color dotColor = index % 2 == 0 ? Colors.red : Colors.green;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 8),
                height: 24,
                width: 24,
                decoration: BoxDecoration(border: Border.all(color: dotColor)),
                child: Icon(
                  Icons.circle,
                  color: dotColor,
                  size: 16,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.strMeal ?? 'Title not available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '₹ ${food.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${food.calorise * index} Calories',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Details: ${food.strMeal ?? 'Details not available'}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(
                      height: 16,
                    ),
                    increseDecreseButton(food: food, index: index),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              //  const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget increseDecreseButton({required Food food, required int index}) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(1, 69, 4, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (food.numCount != 0) {
                  orderPageController.incrementDecrementCounter(
                      food: food, index: index, isAdd: false);
                }
              },
              icon: const Icon(Icons.remove, color: Colors.white)),
          Text(
            '${food.numCount}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          IconButton(
              onPressed: () {
                orderPageController.incrementDecrementCounter(
                    food: food, index: index, isAdd: true);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Widget placeOrderButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ElevatedButton(
          onPressed: () {
            Get.defaultDialog(
              title: 'Thank You',
              middleText: 'Thank you for placeinf order!',
              textConfirm: 'OK',
              confirmTextColor: Colors.white,
              buttonColor: Colors.blue,
              onConfirm: () {
                Get.back();
                Get.back(result: true);
              },
            );
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(const Color.fromRGBO(1, 69, 4, 1)),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
            elevation: MaterialStateProperty.all(1),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //     const EdgeInsets.only(bottom: 5)),
          ),
          child: Text(StringConstant.placeOrder,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700))),
    );
  }
}
