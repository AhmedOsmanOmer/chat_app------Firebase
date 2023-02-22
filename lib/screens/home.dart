// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/controllers/home_controller.dart';
import 'package:lets_chat/main.dart';
import 'package:lets_chat/screens/chat_screen.dart';
import 'package:lets_chat/screens/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Home_Controller home_controller = Home_Controller();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(pref.getString('id').toString())
        .update({'status': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Home_Controller>(
        init: Home_Controller(),
        builder: (controller) {
          return Scaffold(
              drawer: const Drawer(child: Drawerr()),
              floatingActionButton: IconButton(
                  icon: const Icon(Icons.logout, size: 50),
                  onPressed: () {
                    pref.clear();
                    //controller.logout();
                  }),
              backgroundColor: const Color.fromARGB(255, 221, 243, 255),
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(pref.getString('image_url').toString()),
                      radius: 35,
                    ),
                  ),
                ],
                title: const Center(
                    child:
                        Text("Chats", style: TextStyle(color: Colors.white))),
                elevation: 0,
              ),
              body: controller.isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 100,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                            color: Colors.blueGrey),
                        //////
                        ///
                        ///Search Bar
                        child: TextField(
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          controller: controller.search,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              label: const Text(
                                "Search",
                                style: TextStyle(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.onSearch();
                                  },
                                  icon: const Icon(Icons.search,
                                      color: Colors.white))),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (ctx, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 0.5, horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blueGrey,
                                    ),
                                    child: ListTile(
                                        onTap: () {
                                          String chatId = controller.chatRoomID(
                                              pref.getString('name').toString(),
                                              streamSnapshot.data!.docs[index]
                                                  ['name']);
                                          Map<String, dynamic> userMap = {
                                            'name': streamSnapshot
                                                .data!.docs[index]['name'],
                                            'doc_id': streamSnapshot
                                                .data!.docs[index]['doc_id']
                                          };

                                          Get.to(() => Chat_Screen(
                                              chatId: chatId,
                                              userMap: userMap));
                                        },
                                        subtitle: Text(streamSnapshot
                                            .data!.docs[index]['status']),
                                        leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                streamSnapshot.data!.docs[index]
                                                    ['image_url'])),
                                        title: Text(streamSnapshot
                                            .data!.docs[index]['name']),
                                        trailing: Icon(Icons.circle,
                                            color: streamSnapshot.data!.docs[index]
                                                        ['status'] ==
                                                    'Online'
                                                ? Colors.green
                                                : Colors.red)),
                                  ));
                        },
                      ),
                      controller.userMap != null
                          ? ListTile(
                              onTap: () {
                                String chatId = controller.chatRoomID(
                                    pref.getString('name').toString(),
                                    controller.userMap!['name']);
                                Get.to(() => Chat_Screen(
                                    chatId: chatId,
                                    userMap: controller.userMap!));
                              },
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(controller
                                      .userMap!['image_url']
                                      .toString())),
                              title: Text(controller.userMap!['name']),
                              subtitle: Text(controller.userMap!['email']),
                            )
                          : const Center(child: Text("No Chat"))
                    ])));
        });
  }
}
