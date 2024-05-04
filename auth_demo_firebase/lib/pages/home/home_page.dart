import 'package:auth_demo_firebase/main.dart';
import 'package:auth_demo_firebase/model/food_list.dart';
import 'package:auth_demo_firebase/pages/home/home_page_controller.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:auth_demo_firebase/utils/utils.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  final HomePageContoller _homePageContoller = Get.put(HomePageContoller());

  @override
  void initState() {
    tabController = TabController(length: 7, vsync: this);
    tabControlerrReUpdate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideNav(),
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              GestureDetector(
                  onTap: () {
                    if (_homePageContoller.totalCartCount.value != 0) {
                      Get.toNamed(AppRoutes.order, arguments: {
                        ArgumentKey.selectedFoodList:
                            _homePageContoller.getSelectedFood(),
                        ArgumentKey.totalcartCount:
                            _homePageContoller.totalCartCount
                      })?.then((value) {
                        if (value == true) {
                          _homePageContoller.clearAllData();
                        }
                      });
                    } else {
                      Utils.showSnakBar(
                          title: 'Empty Cart',
                          content: 'Your cart is empty please add item first.');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.trolley,
                      size: 32,
                    ),
                  )),
              Positioned(
                right: 8,
                top: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(9)),
                  child: Center(
                    child: GetBuilder<HomePageContoller>(
                        init: HomePageContoller(),
                        builder: (controller) {
                          return Text(
                            '${controller.totalCartCount}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          );
                        }),
                  ),
                ),
              )
            ],
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 40),
            child: Obx(
              () => _homePageContoller.tabTitles.isEmpty
                  ? const SizedBox()
                  : TabBar(
                      tabAlignment: TabAlignment.start,
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade300),
                      indicatorColor: Colors.red.shade300,
                      controller: tabController,
                      isScrollable: true,
                      onTap: (value) {
                        _homePageContoller.strCat =
                            _homePageContoller.tabTitles[value];
                        _homePageContoller.basedOngetMeals();
                      },
                      tabs: _homePageContoller.tabTitles.map((title) {
                        return Container(width: 90, child: Tab(text: title));
                      }).toList(),
                    ),
            )),
      ),
      body: Obx(() {
        if (_homePageContoller.isLoading.value) {
          return Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 195, 236, 204),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              padding: const EdgeInsets.all(50),
              child: const CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        }
        return GetBuilder<HomePageContoller>(
            init: HomePageContoller(),
            builder: (controller) {
              return ListView.builder(
                  itemCount: _homePageContoller.foodList.length,
                  itemBuilder: (_, int index) {
                    return productTile(
                        food: _homePageContoller.foodList[index], index: index);
                  });
            });
      }),
    );
  }

  Widget productTile({required Food food, required int index}) {
    Color dotColor = index % 2 == 0 ? Colors.red : Colors.green;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)),
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
              SizedBox(
                  height: 58,
                  width: 74,
                  child: imgSlider(
                      url: food.strMealThumb ??
                          'https://via.placeholder.com/58x58'))
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
          color: Colors.green.shade400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (food.numCount != 0) {
                  _homePageContoller.incrementDecrementCounter(
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
                _homePageContoller.incrementDecrementCounter(
                    food: food, index: index, isAdd: true);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget imgSlider({required String url}) {
    final List<String> imageUrls = [url];
    return CarouselSlider(
      options: CarouselOptions(
        height: 58.0,
        aspectRatio: 1.0,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 74.0,
                height: 58.0,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  void tabControlerrReUpdate() {
    _homePageContoller.getCategory().then((value) {
      tabController?.dispose();
      tabController = TabController(
          length: _homePageContoller.tabTitles.length, vsync: this);
      setState(() {});
    });
  }

  Drawer sideNav() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                        height: 58,
                        width: 58,
                        agenraricCtrollerclass.googleSignInUserData?.photoUrl ??
                            'https://via.placeholder.com/58x58')),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  agenraricCtrollerclass.googleSignInUserData?.displayName ??
                      "name",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  agenraricCtrollerclass.googleSignInUserData?.id ?? "Id",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Get.dialog(AlertDialog(
                  title: Text(StringConstant.logoutTitle),
                  content: Text(StringConstant.areYouSure),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(StringConstant.cancel,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        final GoogleSignIn googleSignIn = GoogleSignIn();
                        googleSignIn.signOut();
                        Get.offAllNamed(AppRoutes.authPageROute);
                      },
                      child: Text(
                        StringConstant.logout,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                      ),
                    ),
                  ],
                ));
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Text(
                    StringConstant.logout,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          // Text(
          //   StringConstant.categories,
          //   style: const TextStyle(
          //       color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
          // ),
          //By uncommenty this code uyou can see all cat list and move tab controller also manage
          // Obx(
          //   () => Container(
          //     height: MediaQuery.of(context).size.height * 0.6,
          //     color: Colors.white,
          //     child: ListView.builder(
          //         itemCount: _homePageContoller.categoriesList.length,
          //         itemBuilder: (_, int index) {
          //           String title =
          //               _homePageContoller.categoriesList[index].strCategory;
          //           return GestureDetector(
          //             onTap: () {
          //               tabController?.animateTo(index);
          //               _homePageContoller.strCat =
          //                   _homePageContoller.tabTitles[index];
          //               _homePageContoller.basedOngetMeals();
          //               Get.back();
          //             },
          //             child: Container(
          //                 margin: const EdgeInsets.all(8),
          //                 padding: const EdgeInsets.all(16),
          //                 child: Row(
          //                   children: [
          //                     Text(
          //                       title,
          //                       style: const TextStyle(
          //                           fontSize: 14, color: Colors.blue),
          //                     ),
          //                     const Spacer(),
          //                     const Icon(Icons.arrow_forward,
          //                         color: Colors.grey)
          //                   ],
          //                 )),
          //           );
          //         }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
