import 'package:auth_demo_firebase/pages/authentication/signin_controller.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GoogleSignPage extends StatefulWidget {
  const GoogleSignPage({super.key});

  @override
  State<GoogleSignPage> createState() => _GoogleSignPageState();
}

class _GoogleSignPageState extends State<GoogleSignPage> {
  final SignCOntroller _signController = Get.put(SignCOntroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageConstant.firebaseImage),
              const SizedBox(
                height: 36,
              ),
              button(),
              const SizedBox(
                height: 18,
              ),
              mobilebutton()
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Obx(
      () => ElevatedButton(
          onPressed: () {
            _signController.signInWithGoogle();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
            elevation: MaterialStateProperty.all(1),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: (!_signController.loading.value)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageConstant.googleImg,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Text(StringConstant.googleText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ],
                )
              : const CircularProgressIndicator(
                  color: Colors.white,
                )),
    );
  }

  Widget mobilebutton() {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green.shade400),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(StringConstant.phoneText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ));
  }
}
