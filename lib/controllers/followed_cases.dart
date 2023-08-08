// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nouga/controllers/home_case.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class FollowedCases extends StatefulWidget {
  String userEmail;
  FollowedCases({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<FollowedCases> createState() => _FollowedCasesState();
}

class _FollowedCasesState extends State<FollowedCases> {
  Globals globals = Globals();
  @override
  Widget build(BuildContext context) {
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
        child: displayFavList(),
      ),
    );
  }

  Future<List> getFavListFromUser({required String userEMAIL}) async {
    List favList = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection('favorites').doc(userEMAIL).get();
    favList = querySnapshot.data()?.values.toList() ?? [];
    return favList;
  }

  displayFavList() {
    Future<List> userFavList = getFavListFromUser(userEMAIL: widget.userEmail);
    return Expanded(
      child: FutureBuilder<List>(
        future: userFavList, // Le futur à attendre
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Le futur est terminé avec succès
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot
                  .data!.length, // Nombre d'éléments dans la liste favList
              itemBuilder: (context, i) {
                return cardCase(
                    caseID: snapshot
                        .data![i]); // Widget à afficher pour chaque élément
              },
            );
          } else if (snapshot.hasError) {
            // Le futur est terminé avec erreur
            return Text('Une erreur est survenue: ${snapshot.error}');
          } else {
            // Le futur est en attente
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: globals.getRainbowMainColor(),
                size: 50,
              ),
            );
          }
        },
      ),
    );
  }

  cardCase({required caseID}) {
    // final caseINFOS = globals.getAllInfosFromCase(caseID: caseID);
    return StreamBuilder(
      stream: globals.getAllInfosFromCase(caseID: caseID),
      builder: (context, snapshot) {
        // if()
        if (snapshot.data?['date'] == null) {
          DateTime date = DateTime(1970);
        } else {
          DateTime date = snapshot.data?['date'].toDate();
        }
        DateTime date = DateTime(1970);
        Duration difference = DateTime.now().difference(date);
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        int minutes = difference.inMinutes % 60;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeCase(id: caseID)),
            );
          },
          child: Card(
            // Define the shape of the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            // Define how the card's content should be clipped
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // Define the child widget of the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add padding around the row widget
                Padding(
                  padding:  EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add an image widget to display an image
                      Image.network(
                        snapshot.data!['photos'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      // Add some spacing between the image and the text
                      Container(width: 20),
                      // Add an expanded widget to take up the remaining horizontal space
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Add some spacing between the top of the card and the title
                            Container(height: 5),
                            // Add a title widget
                            globals.textWithRainbowPolice(
                                align: TextAlign.start,
                                size: 18,
                                weight: FontWeight.w700,
                                color: Colors.black,
                                textData: snapshot.data!['prenom'] +
                                    ' ' +
                                    snapshot.data!['nom']),
                            // Add some spacing between the title and the subtitle
                            Container(height: 5),
                            // Add a subtitle widget
                            globals.textWithRainbowPolice(
                                align: TextAlign.start,
                                size: 15,
                                weight: FontWeight.w600,
                                color: Colors.black,
                                textData:
                                    '${'Disparition : Il y a ' + days.toString()} jour(s)'),
                            // Add some spacing between the subtitle and the text
                            Container(height: 10),
                            // Add a text widget to display some text
                            globals.textWithRainbowPolice(
                                align: TextAlign.start,
                                size: 13,
                                weight: FontWeight.w600,
                                color: Colors.black,
                                textData: snapshot.data!['taille'] +
                                    ' ' +
                                    snapshot.data!['nom']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
