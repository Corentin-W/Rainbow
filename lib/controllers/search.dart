import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
      body: casesList(),
    );
  }

  casesList() {
  return FutureBuilder(
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
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text('No data available.'),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            // Accédez aux données de chaque document ici
            DocumentSnapshot document = snapshot.data.docs[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Construisez votre widget d'élément de liste ici
            Widget listItem = ListTile(
              title: Text(data['title']), // Exemple : utilisez un champ 'title'
              subtitle: Text(data['description']), // Exemple : utilisez un champ 'description'
            );

            return listItem;
          },
        );
      }
    },
  );
}

}
