import 'package:flutter/material.dart';
import 'package:nouga/globals/globals.dart';
import '../globals/drawer.dart';
import 'informations.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Globals globals = Globals();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Rainbow',
          ),
          backgroundColor: const Color.fromARGB(255, 143, 201, 238),
        ),
        drawer: const DrawerGlobal(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: homePage(),
        ));
  }

  homePage() {
    return const Center(
      child: Text('mfdlmf'),
    );
  }
}
