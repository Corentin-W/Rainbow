import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nouga/controllers/followed_cases.dart';
import 'package:nouga/controllers/home_case.dart';
import 'package:nouga/controllers/login.dart';
import 'package:nouga/controllers/search.dart';
import 'package:nouga/controllers/settings_page.dart';
import 'package:nouga/controllers/warning.dart';
import 'package:nouga/globals/globals.dart';
import 'package:nouga/models/person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals/drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userEMAIL = "";
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userEMAIL = prefs.getString('userEmail') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Globals globals = Globals();

    FirebaseFirestore db = FirebaseFirestore.instance;
    testStorage();
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
    final Globals globals = Globals();
    return SizedBox(
      height: 350,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('cases').limit(6).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: globals.getRainbowMainColor(),
                size: 50,
              ),
            );
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
                String pathImage = '';
                if (doc.data()['photos'] != null) {
                  pathImage = doc.data()['photos'];
                } else {
                  pathImage =
                      'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80';
                }
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
                            image: NetworkImage(pathImage),
                            onError: (exception, stackTrace) {
                              NetworkImage(dotenv.env['DEFAULT_PATH_IMAGE']!);
                            },
                          )),
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
                                  // ignore: prefer_interpolation_to_compose_strings
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
                              const SizedBox(
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
              if (userEMAIL == '') {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pas de compte'),
                        content:
                            const Text("Vous n'êtes connecté à aucun compte"),
                        actions: [
                          ListBody(
                            children: [
                              TextButton(
                                child: const Text('Annuler'),
                                onPressed: () {
                                  return Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                          ListBody(
                            children: [
                              TextButton(
                                child: const Text('Se connecter'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                },
                              )
                            ],
                          )
                        ],
                      );
                    });
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Warning()));
              }
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
            onPressed: () {
              if (userEMAIL == '') {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pas de compte'),
                        content:
                            const Text("Vous n'êtes connecté à aucun compte"),
                        actions: [
                          ListBody(
                            children: [
                              TextButton(
                                child: const Text('Annuler'),
                                onPressed: () {
                                  return Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                          ListBody(
                            children: [
                              TextButton(
                                child: const Text('Se connecter'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                },
                              )
                            ],
                          )
                        ],
                      );
                    });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FollowedCases(userEmail: userEMAIL)));
              }
            },
            child: const Icon(Icons.favorite),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Cases suivis')
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
            onPressed: () {
              var box = Hive.box('testbox');
              var boxResult = box.get(1);
              print(boxResult);
              /*  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage())); */
            },
            child: const Icon(Icons.settings),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Parametres')
      ],
    );
  }

  void testStorage() async {
    var myBox = Hive.box('testbox');
    myBox.put(1, 'okéééé');
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('cases')
        .where('user_email', isEqualTo: 'rainbapp@gmail.com')
        .get()
        .then((iterate) {
      print('boucle');
      for (var docUnique in iterate.docs) {
        print(docUnique.data());
      }
    });
  }
}
