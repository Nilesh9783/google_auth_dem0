import 'package:auth_demo_firebase/main.dart';
import 'package:auth_demo_firebase/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

class SignCOntroller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('App state start');
  }

  Future<void> signInWithGoogle() async {
    try {
      loading.value = true;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        agenraricCtrollerclass.googleSignInUserData = googleSignInAccount;

        // Sign in with the credential
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        debugPrint(userCredential.toString());
        loading.value = false;
        Get.offNamed(AppRoutes.home);
      } else {
        loading.value = false;

        print('Google sign in cancelled');
      }
    } catch (e) {
      loading.value = false;
    }
  }
}
