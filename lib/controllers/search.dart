import 'package:flutter/material.dart';

import '../globals/drawer.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Rainbow',
        ),
        backgroundColor: Color.fromARGB(255, 143, 201, 238),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: Text('deweeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeata'),
    );
  }
}
