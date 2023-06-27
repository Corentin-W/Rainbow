import 'package:flutter/material.dart';

import '../globals/drawer.dart';

class NewCase extends StatelessWidget {
  const NewCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Rainbow',
        ),
        backgroundColor: const Color.fromARGB(255, 143, 201, 238),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: form(),
    );
  }

  form() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [name()]),
      ),
    );
  }

  name() {
    return Container(
      width: 100,
      height: 30,
      child: TextField(
        autocorrect: true,
        decoration: InputDecoration(),
      ),
    );
  }
}
