// ignore_for_file: use_build_context_synchronously, camel_case_types, unrelated_type_equality_checks, non_constant_identifier_names, depend_on_referenced_packages, avoid_print, invalid_return_type_for_catch_error, unused_local_variable, avoid_function_literals_in_foreach_calls
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/screens/login.dart';
import 'package:lets_chat/widget/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Auth_Controller extends GetxController {
  double conHight = 620;
  File? myfile;
  String default_image_url =
      "https://firebasestorage.googleapis.com/v0/b/messages-app-91991.appspot.com/o/images%2Fdefault.png?alt=media&token=7a2c0005-bce6-446c-a220-e01c7e5ee8d3";
  bool isValid = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
//////
  ///

  storeUserData(BuildContext context, String id) async {
    if (myfile == null) {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users
          .add({
            'name': name.text,
            'email': email.text, // John Doe
            'image_url': default_image_url,
            'id': id // Stokes and Sons
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      var storage =
          FirebaseStorage.instance.ref("images/${basename(myfile!.path)}");
      await storage.putFile(myfile!);
      String url = await storage.getDownloadURL();
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.add({
        'name': name.text, 
        'email': email.text,
        'image_url': url,
        'id': id,
        'status':'Offline'
      }).then((value) async {
        await users.doc(value.id).update({
          'doc_id': value.id,
        });
        print("User Added");
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  signUp(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    if (formKey.currentState!.validate()) {
      isValid = true;
      conHight = 620;
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        if (kDebugMode) {
          print("done ////////////////////////////////");
        }
        storeUserData(context, auth.currentUser!.uid);
         FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.text)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            FirebaseFirestore.instance.collection('users').doc(doc.id).update({
              'doc_id':doc.id
            });
          });
        });
        Get.to(() => const Login());
        showMessage(context, "Sign Up Success.. You Can Log in Now",
            DialogType.success);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showMessage(context, "Password Is Too Weak", DialogType.warning);
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showMessage(context, "Email Already In Use", DialogType.warning);
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      isValid == false;
      conHight = 700;
    }
    update();
  }

  ////
  ///

  chooseImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) => Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20),
              height: 150,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () async {
                        XFile? xfile = await ImagePicker()
                            .pickImage(source: ImageSource.camera)
                            .whenComplete(() {
                          update();
                        });
                        myfile = File(xfile!.path);
                        update();
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.camera_enhance, size: 60),
                          Text("From Camera"),
                        ],
                      )),
                  const SizedBox(height: 15),
                  InkWell(
                      onTap: () async {
                        XFile? xfile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .whenComplete(() {
                          update();
                        });
                        myfile = File(xfile!.path);
                        update();
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.photo, size: 60),
                          Text("From Gallery"),
                        ],
                      )),
                ],
              ),
            ));
    update();
  }
}
