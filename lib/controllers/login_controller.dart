// ignore_for_file: camel_case_types, unused_local_variable, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/main.dart';
import 'package:lets_chat/screens/home.dart';
import 'package:lets_chat/screens/login.dart';
import 'package:lets_chat/widget/widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login_Controller extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
//////
  ///
  ///
  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text);
        print("////////////");
        FirebaseFirestore.instance
            .collection('users').where('email',isEqualTo: email.text)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            pref.setString('id', doc.id);
            pref.setString('email', doc['email']);
            pref.setString('name', doc['name'].toString());
            pref.setString('image_url', doc['image_url'].toString());
          });
        });
        Get.offAll(() => const Home());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showMessage(context, "User Not Found", DialogType.error);
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showMessage(context, "Wrong Password", DialogType.error);
          print('Wrong password provided for that user.');
        } else {
          showMessage(
              context, "Username And Password Incorrect", DialogType.error);
        }
      }
    } else {}
  }

  ///
  ///
  GoogleSignInAccount? googleUser;
  signInWithGoogle() async {
    googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      pref.setString('email', value.user!.email.toString());
      pref.setString('name', value.user!.displayName.toString());
      pref.setString('image_url',value.user!.photoURL.toString());
      print("================================================================");
      Get.to(()=>const Home());
    });

  }

  logout() async {
     googleUser = await GoogleSignIn().signOut();
    pref.clear();
   Get.offAll(()=>const Login());
  }
}
