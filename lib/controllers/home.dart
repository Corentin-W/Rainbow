import 'package:flutter/material.dart';
import 'package:nouga/controllers/new_case.dart';
import 'package:nouga/globals/globals.dart';
import '../globals/drawer.dart';
import 'informations.dart';

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
        drawer: DrawerGlobal(contextFrom: context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: homePage(),
        ));
  }

  homePage() {
    return Center(
      child: Column(
        children: [actionsButton(), actionsButton2()],
      ),
    );
  }

  actionsButton() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [addButton(), searchButton()],
      ),
    );
  }

  actionsButton2() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [favoriteButton(), settingsButton()],
      ),
    );
  }

  addButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            heroTag: 'addButton',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewCase()));
            },
            child: Icon(Icons.add),
          ),
        ),
        SizedBox(height: 5),
        Text('Ajouter un case')
      ],
    );
  }

  searchButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            heroTag: 'searchButton',
            onPressed: () {},
            child: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 5),
        Text('Chercher un case')
      ],
    );
  }

  favoriteButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            heroTag: 'favoriteButton',
            onPressed: () {},
            child: Icon(Icons.favorite),
          ),
        ),
        SizedBox(height: 5),
        Text('Chercher un case')
      ],
    );
  }

  settingsButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            heroTag: 'settingsButton',
            onPressed: () {},
            child: Icon(Icons.settings),
          ),
        ),
        SizedBox(height: 5),
        Text('Chercher un case')
      ],
    );
  }
}
