// ignore_for_file: library_private_types_in_public_api


import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:lets_chat/controllers/login_controller.dart';
import 'package:lets_chat/screens/signUp.dart';
import 'package:lets_chat/widget/widget.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 221, 243, 255),
        body: SingleChildScrollView(
            child:GetBuilder<Login_Controller>(
              init: Login_Controller(),
              builder: (controller) =>Column(
                          children: [
                            ClipPath(
                              clipper: WaveClipperOne(flip: true),
                              child: Container(
                                height: 200,
                                width: 500,
                                color: Colors.blueGrey,
                                child: const Center(
                                    child: Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                      fontFamily: "tangerine",
                                      color: Colors.white,
                                      fontSize: 50),
                                )),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 80, bottom: 60),
                                padding: const EdgeInsets.only(
                                    top: 65, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(60)),
                                height:  380,
                                width: 350,
                                child: Column(
                                  children: [
                                    Form(
                                        key: controller.formKey,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text_Form(
                                                  const Icon(Icons.email,
                                                      color: Colors.white),
                                                  "Email",
                                                  false,
                                                  controller.email),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text_Form(
                                                  const Icon(Icons.password,
                                                      color: Colors.white),
                                                  "Password",
                                                  true,
                                                 controller.password),
                                              const SizedBox(height: 30),
                                              InkWell(
                                                onTap: () async {
                                                  controller.login(context);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  padding: const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      left: 40,
                                                      right: 40),
                                                  decoration: BoxDecoration(
                                                      color: const Color.fromARGB(
                                                          255, 221, 243, 255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: const [
                                                      Text("Login "),
                                                      Icon(Icons.login_sharp)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.off(() => const SignUp());
                                                },
                                                child: const Text(
                                                  "Dont have account",
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ]))
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                    onTap: () async {
                                     await controller.signInWithGoogle();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            "Login With Google",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 17),
                                          ),
                                          const SizedBox(width: 10),
                                          Image.asset(
                                            'icons/google.png',
                                            height: 30,
                                            width: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  )]))));
            
                    
}
}