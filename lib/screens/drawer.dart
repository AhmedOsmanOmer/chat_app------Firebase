import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/controllers/drawer_controller.dart';
import 'package:lets_chat/main.dart';

class Drawerr extends StatefulWidget {
  const Drawerr({super.key});

  @override
  State<Drawerr> createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Drawr_Controller>(
      init: Drawr_Controller(),
      builder: (controller) {
        return Column(
          children: [
            const SizedBox(height: 50),
            InkWell(
              onTap: () {
                controller.chooseImage(context);
              },
              child: Stack(children: [
                CircleAvatar(
                   backgroundImage:
                        NetworkImage(pref.getString('image_url').toString()),
                    backgroundColor: Colors.teal,
                    radius: 60),
                const Positioned(
                    height: 200,
                    left: 80,
                    child: CircleAvatar(child: Icon(Icons.edit)))
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  ListTile(title: const Text("Dark Mode"),trailing: IconButton(icon: const Icon(Icons.dark_mode),onPressed: (){})),
                  ListTile(title: const Text("Logout"),trailing: IconButton(icon: const Icon(Icons.logout),onPressed: (){})),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}
