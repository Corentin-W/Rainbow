// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    final caseINFOS = globals.getAllInfosFromCase(caseID: caseID);

    return StreamBuilder(
      stream: globals.getAllInfosFromCase(caseID: caseID),
      builder: (context, snapshot) {
        return const Text('data');
      },
    );
  }
}
