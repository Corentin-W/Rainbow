import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home_case.dart';
import 'package:nouga/controllers/search.dart';
import 'package:nouga/controllers/warning.dart';
import 'package:nouga/globals/globals.dart';
import '../globals/drawer.dart';
import 'package:intl/intl.dart';

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
          title: Column(
            children: [
              globals.getRainbowLogo(height: 80, width: 100, withName: false),
              const SizedBox(height: 10)
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        drawer: DrawerGlobal(contextFrom: context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: homePage(context: context),
        ));
  }

  homePage({required BuildContext context}) {
    Globals globals = Globals();
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            actionsButton(),
            actionsButton2(),
            const SizedBox(height: 20),
            globals.textWithRainbowPolice(
                textData: 'Derniers cases ouverts',
                weight: FontWeight.w700,
                align: TextAlign.center,
                size: 20),
            lastCases(context: context),
          ],
        ),
      ),
    );
  }

  lastCases({required BuildContext context}) {
    final Globals globals = new Globals();
    return SizedBox(
      height: 350,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('cases').limit(6).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                DateTime date = doc.data()['date'].toDate();
                Duration difference = DateTime.now().difference(date);

                int days = difference.inDays;
                int hours = difference.inHours % 24;
                int minutes = difference.inMinutes % 60;
                return Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeCase(id: doc.id)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://www.missnumerique.com/blog/wp-content/uploads/reussir-sa-photo-de-profil-michael-dam.jpg'))),
                      width: 270,
                      height: 320,
                      child: ListTile(
                        title: globals.textWithRainbowPolice(
                            textData:
                                doc.data()['prenom'] + ' ' + doc.data()['nom'],
                            align: TextAlign.left,
                            size: 13,
                            weight: FontWeight.w900,
                            color: Colors.white),
                        subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              globals.textWithRainbowPolice(
                                  textData: 'Vu(e) pour la derniere fois a ' +
                                      doc.data()['localisation'],
                                  align: TextAlign.left,
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: Colors.white),
                              globals.textWithRainbowPolice(
                                  textData:
                                      'Disparu(e) depuis $days jours, $hours heure(s) et $minutes minute(s)',
                                  align: TextAlign.left,
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: Colors.white),
                              SizedBox(
                                height: 50,
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
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
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Warning()));
            },
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 87, 49, 49),
            ),
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
            heroTag: 'search',
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
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
            heroTag: 'favorite',
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
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
            heroTag: 'settings',
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
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
