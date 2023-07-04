import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/search.dart';
import 'package:nouga/controllers/warning.dart';
import 'package:nouga/globals/globals.dart';
import '../globals/drawer.dart';

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
      child: Expanded(
        child: Column(
          children: [
            actionsButton(),
            actionsButton2(),
            const SizedBox(height: 20),
            lastCases()
          ],
        ),
      ),
    );
  }

  lastCases() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('cases').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(snapshot.data!.docs[index]['nom']),
                  subtitle: Text(snapshot.data!.docs[index]['prenom']),
                ),
              );
            },
          ),
        );
      },
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
                  MaterialPageRoute(builder: (context) => const Warning()));
            },
            child: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Ajouter un case')
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const Search())));
            },
            child: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
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
            child: const Icon(Icons.favorite),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
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
            child: const Icon(Icons.settings),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
      ],
    );
  }
}
