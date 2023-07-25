// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';
import '../models/storage/storage.dart';

class PicturesCase extends StatefulWidget {
  String caseID;
  PicturesCase({
    Key? key,
    required this.caseID,
  }) : super(key: key);

  @override
  State<PicturesCase> createState() => _PicturesCaseState();
}

class _PicturesCaseState extends State<PicturesCase> {
  @override
  Widget build(BuildContext context) {
    Storage storageInstance = Storage();
    Future<dynamic> picturesList =
        storageInstance.getPicturesFromCase(caseID: widget.caseID);
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
      body: FutureBuilder(
          future: picturesList,
          builder: ((context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Pendant que la récupération des images est en cours
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // En cas d'erreur lors de la récupération des images
              return Center(
                  child: Text("Erreur lors du chargement des images"));
            } else {
              List<dynamic> images = snapshot.data;
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final url = images[index];
                    print('salu');
                    print(url.toString());
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: images.length);
            }
          })),
    );
  }
}
