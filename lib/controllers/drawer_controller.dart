// ignore_for_file: depend_on_referenced_packages, camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/main.dart';
import 'package:path/path.dart';

class Drawr_Controller extends GetxController {
  File? myfile;
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
                        var upload = await FirebaseStorage.instance
                            .ref()
                            .child('images')
                            .child(basename(myfile!.path).toString())
                            .putFile(myfile!);
                        var url = await upload.ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(pref.getString('id').toString())
                            .update({'image_url': url});
                        pref.setString('image_url', url);

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
                            .pickImage(source: ImageSource.gallery);

                        myfile = File(xfile!.path);
                        var upload = await FirebaseStorage.instance
                            .ref()
                            .child('images')
                            .child(basename(myfile!.path).toString())
                            .putFile(myfile!);
                        var url = await upload.ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(pref.getString('id').toString())
                            .update({'image_url': url});
                        pref.setString('image_url', url);
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
