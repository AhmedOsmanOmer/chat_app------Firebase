// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors, await_only_futures, avoid_print, unnecessary_null_comparison, body_might_complete_normally_catch_error

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/main.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:lets_chat/widget/widget.dart';
import 'package:uuid/uuid.dart';

class Chat_Screen extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatId;
  const Chat_Screen({super.key, required this.userMap, required this.chatId});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  bool isLoading = true;
  File? imageFile;
  TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController list_controller = ScrollController();
 
  getGalaryImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  getCameraImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  uploadImage() async {
    String fileName =  Uuid().v1();
    int status = 1;
    await firestore
        .collection('chatroom')
        .doc(widget.chatId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendby': pref.getString('name').toString(),
      'message': "msg",
      'type': 'img',
      'time': FieldValue.serverTimestamp(),
    });
    var ref = await FirebaseStorage.instance
        .ref()
        .child('images')
        .child("$fileName.jpg");
    var upload = await ref.putFile(imageFile!).catchError((onError) async {
      await firestore
          .collection('chatroom')
          .doc(widget.chatId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      var imageUrl = await upload.ref.getDownloadURL();
      await firestore
          .collection('chatroom')
          .doc(widget.chatId)
          .collection('chats')
          .doc(fileName)
          .update({
        'message': imageUrl,
      });
    }
  }

  void sendMessage(String msg) async {
    if (msg != null) {
      final Map<String, dynamic> messages = {
        'sendby': pref.getString('name').toString(),
        'message': msg,
        'type': 'text',
        'time': FieldValue.serverTimestamp(),
      };
      message.clear();
      await firestore
          .collection('chatroom')
          .doc(widget.chatId)
          .collection('chats')
          .add(messages);
      messages.clear();
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: firestore
                .collection('users')
                .doc(widget.userMap['doc_id'])
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot != null) {
                return Row(
                  children: [
                    CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data['image_url'])),
                    const SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.userMap['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const TextSpan(text: "\n"),
                          TextSpan(text: snapshot.data['status'])
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return const Text("No data");
              }
            }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chat_wall.jpg'), fit: BoxFit.fill)),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('chatroom')
                          .doc(widget.chatId)
                          .collection('chats')
                          .orderBy("time", descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(" No data");
                        }
                        if (snapshot.data != null) {
                          return ListView.builder(
                              controller: list_controller,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                return messages(map);
                              });
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            MessageBar(
              onSend: (_) {
                sendMessage(_);
                list_controller.animateTo(
                    list_controller.position.minScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {
                    getCameraImage();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.photo,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () {
                      getGalaryImage();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  