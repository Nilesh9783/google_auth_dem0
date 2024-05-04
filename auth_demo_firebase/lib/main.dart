import 'package:auth_demo_firebase/pages/authentication/sign_in_page.dart';
import 'package:auth_demo_firebase/firebase_options.dart';
import 'package:auth_demo_firebase/pages/home/home_page.dart';
import 'package:auth_demo_firebase/pages/card_and_order/order_page.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:auth_demo_firebase/utils/genraic_controller.dart';
import 'package:auth_demo_firebase/utils/services/api_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

//it is help to create singleton object or our service clas
GetIt sl = GetIt.instance; //Singletone helper
AgenraricCtrollerclass agenraricCtrollerclass = AgenraricCtrollerclass();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocater();
  runApp(const MyApp());
}

void setupServiceLocater() {
  sl.registerLazySingleton<APIServices>(() => APIServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'loginPage',
      title: 'Flutter Demo',
      //defaultTransition: Transition.rightToLeft,
      getPages: [
        GetPage(
            name: AppRoutes.authPageROute, page: () => const GoogleSignPage()),
        GetPage(name: AppRoutes.home, page: () => const HomePage()),
        GetPage(name: AppRoutes.order, page: () => const MyOrder())
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //   home: const GoogleSignPage(),
    );
  }
}
