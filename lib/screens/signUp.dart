// ignore_for_file: library_private_types_in_public_api, file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:lets_chat/controllers/signup_controller.dart';
import 'package:lets_chat/screens/login.dart';
import 'package:lets_chat/widget/widget.dart';
import 'package:validators/validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          ClipPath(
            clipper: WaveClipperOne(flip: true),
            child: Container(
              height: 130,
              width: 500,
              color: const Color.fromARGB(255, 40, 10, 51),
              child: const Center(
                  child: Text(
                "Registration",
                style: TextStyle(
                    fontFamily: "tangerine", color: Colors.white, fontSize: 50),
              )),
            ),
          ),
          GetBuilder<Auth_Controller>(
              init: Auth_Controller(),
              builder: (controller) {
                return Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 60),
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 40, 10, 51),
                      borderRadius: BorderRadius.circular(60)),
                  height: controller.conHight,
                  width: 350,
                  child: Column(
                    children: [
                      Form(
                          key: controller.formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.chooseImage(context);
                                  },
                                  child: Stack(children: [
                                    controller.myfile == null
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/default.png"),
                                            backgroundColor: Colors.blueGrey,
                                            radius: 60)
                                        : CircleAvatar(
                                            backgroundImage:
                                                FileImage(controller.myfile!),
                                            backgroundColor: Colors.teal,
                                            radius: 60),
                                    const Positioned(
                                        height: 200,
                                        left: 80,
                                        child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(255, 40, 10, 51),
                                            child: Icon(Icons.camera_alt)))
                                  ]),
                                ),
                                const SizedBox(height: 20),
                                Text_Form(
                                    const Icon(Icons.person,
                                        color: Colors.white),
                                    "Name",
                                    false,
                                    controller.name),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    cursorColor: Colors.black,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Fill This Field Please ';
                                      } else if (!isEmail(value)) {
                                        return 'invaild Email';
                                      }
                                      return null;
                                    },
                                    controller: controller.email,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      prefixIcon: const Icon(Icons.email,
                                          color: Colors.white),
                                      label: const Text(
                                        "Email",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                passwordField("Password", controller.password,
                                    controller.repassword),
                                const SizedBox(
                                  height: 20,
                                ),
                                passwordField(
                                    "Confirm Password",
                                    controller.repassword,
                                    controller.password),
                                const SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    controller.signUp(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 40,
                                        right: 40),
                                    decoration: BoxDecoration(
                                        color:Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text("SignUp ",style: TextStyle(color: Color.fromARGB(255, 40, 10, 51)),),
                                        Icon(Icons.app_registration)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    // print(image_url+basename(controller.myfile!.path));
                                    Get.off(() => const Login());
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ])),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }),
        ])));
  }
}
