// ignore_for_file: non_constant_identifier_names, avoid_print


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/main.dart';
import 'package:lets_chat/screens/image_view.dart';

//

Widget Text_Form(
    Icon icon, String hint, bool obsec, TextEditingController controller) {
  return TextFormField(
      cursorColor: Colors.black,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Fill This Field Please ';
        }
        return null;
      },
      controller: controller,
      obscureText: obsec,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedErrorBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: icon,
        label: Text(
          hint,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ));
}

///
///
Widget passwordField(String hint,TextEditingController controller, TextEditingController controller2) {
  return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Fill This Field Please ';
        } else if (value.length < 6) {
          return 'Short Password';
        } else if (controller.text != controller2.text) {
          return 'Password not match';
        }
        return null;
      },
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedErrorBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: const Icon(Icons.password, color: Colors.white),
        label:  Text(
          hint,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ));
}

///
///

showMessage(BuildContext context, String msg, DialogType dialog) {
  AwesomeDialog(
      context: context,
      dialogBackgroundColor: const Color.fromARGB(255, 221, 243, 255),
      body: Text(msg),
      dialogType: dialog,
      btnOk: TextButton(
          child: const Text("OK"),
          onPressed: () {
            Get.back();
          })).show();
}

showSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Message',
      message: msg,
      contentType: ContentType.warning,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Timestamp? time;
  Widget messages(Map<String, dynamic> map) {
    time = map['time'];
    DateTime date = time!.toDate();
    print(date);
    return map['type'] == 'text'
        ? Column(
            children: [
              BubbleSpecialOne(
                sent: true,
                isSender:
                    map['sendby'] == pref.getString('name') ? true : false,
                text: map['message'],
                color: map['sendby'] == pref.getString('name')
                    ? Colors.red
                    : Colors.yellow,
                tail: true,
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Align(
                  alignment: map['sendby'] == pref.getString('name')
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(
                      "${date.hour}:${date.minute}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ))
            ],
          )
        : Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ImageView(
                        image_url: map['message'],
                      ));
                },
                child: Align(
                   alignment: map['sendby'] == pref.getString('name')
                          ? Alignment.topRight
                          : Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(50)
                    ),
                      margin: const EdgeInsets.all(10),  
                      child: map['message'] != ""
                          ? SizedBox(height: 180,width: 130, child: Image.network(map['message'],fit: BoxFit.fill,height: 200,))
                          : const CircularProgressIndicator(
                              color: Colors.amberAccent,
                            )),
                ),
              ),
              Align(
                  alignment: map['sendby'] == pref.getString('name')
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(
                      
                      "${date.hour}:${date.minute}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ))
            ],
          );
  }

