// ignore_for_file: camel_case_types, await_only_futures, avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/main.dart';

class Home_Controller extends GetxController{
  TextEditingController search=TextEditingController();
  Map<String,dynamic>? userMap;
  bool isLoading=false;
  onSearch() async{
    FirebaseFirestore firestore=await FirebaseFirestore.instance;
    isLoading=true;
    update();
    firestore.collection('users').where('email',isEqualTo: search.text).get().then((value) {
      print("000000000000000000000000000000000${pref.getString('reciver_id')}");
      userMap=value.docs[0].data();
      ////////Add Id to Map 
      isLoading=false;
      update();
    });
    print(userMap);
    print("=================================================================================");
  }
  
  String getChatid(String user1,String user2){
    DocumentReference chat_id=FirebaseFirestore.instance.collection('chatroom').doc('$user1$user2');
    if(chat_id==null){
    return "$user2$user1";
    }
    else{
      return "$user1$user2";
    }
  }
  String chatRoomID(String user1,String user2){
    if(user1[0].toLowerCase().codeUnits[0]>user2[0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }
    else{
      return "$user2$user1";
    }
  }
}