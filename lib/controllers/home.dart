import 'package:flutter/material.dart';
import 'package:nouga/globals/globals.dart';
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
      body: SliderDrawer(
        slider: Container(color: Colors.red),
        appBar: SliderAppBar(
            appBarColor: Colors.white,
            title: Text('title',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700))),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
              child: Column(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(
                    'https://static.wikia.nocookie.net/cartoons/images/e/ed/Profile_-_SpongeBob_SquarePants.png/revision/latest?cb=20230305115632'),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(
                    'https://static.wikia.nocookie.net/cartoons/images/e/ed/Profile_-_SpongeBob_SquarePants.png/revision/latest?cb=20230305115632'),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(
                    'https://static.wikia.nocookie.net/cartoons/images/e/ed/Profile_-_SpongeBob_SquarePants.png/revision/latest?cb=20230305115632'),
              )
            ],
          )),
        ),
      ),
    );
  }
}
