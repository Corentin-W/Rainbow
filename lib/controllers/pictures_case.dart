// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home_case.dart';

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
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 50,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(snapshot.data[index]),
                    ),
                  ),
                  child: Stack(
                    // Use a Stack to overlay the IconButton on the Container
                    children: [
                      // The IconButton is placed at the top-right corner of the Container
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          color: globals.getRainbowMainColor(),
                          iconSize: 42,
                          icon: const Icon(Icons.more_horiz_sharp),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Suppression'),
                                  content: Text(
                                      'Voulez-vous supprimer cette photo ?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Annuler'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Supprimer'),
                                      onPressed: () {
                                        storageInstance.deleteFileFromUrl(
                                            snapshot.data[index]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeCase(
                                                    id: widget.caseID)));
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 30);
              },
            );
          } else {
            return Text('hello');
          }
        },
      ),
    );
  }
}
