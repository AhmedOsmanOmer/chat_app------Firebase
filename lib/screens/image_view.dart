// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final image_url;
   const ImageView({super.key, this.image_url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.network(image_url),
      ),
    );
  }
}