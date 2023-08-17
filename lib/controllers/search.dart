import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nouga/controllers/home_case.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Globals globals = Globals();
  String? searchText;
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
      body: casesList(),
    );
  }

  casesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
            decoration: const InputDecoration(
              labelText: 'Rechercher',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('cases').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: globals.getRainbowMainColor(),
                    size: 50,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data available.'),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    // Vérifiez si le texte de recherche correspond à certains champs de données
                    if(searchText != null){
bool matchesSearch =
                        data['prenom'].toLowerCase().contains(searchText) ||
                            data['nom'].toLowerCase().contains(searchText);

                    if (!matchesSearch) {
                      return Container(); // Ne pas afficher l'élément s'il ne correspond pas à la recherche
                    }
                    }
                    

                    late String img;
                    if (data["photos"] == null) {
                      img = dotenv.env['DEFAULT_PATH_IMAGE']!;
                    } else {
                      img = data["photos"];
                    }
                    return Column(
                      children: [
                        ListTile(
                          leading: Image.network(img, width: 50, height: 50),
                          title: Row(
                            children: [
                              Text(data['prenom']),
                              const SizedBox(width: 5),
                              Text(data['nom']),
                            ],
                          ),
                          subtitle: Text(data['localisation']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeCase(id: document.id)),
                            );
                          },
                        ),
                        Divider()
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
