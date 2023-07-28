import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home_case.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../globals/drawer.dart';
import '../globals/globals.dart';
import '../models/storage/storage.dart';
import 'package:image_picker/image_picker.dart';

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
  Storage storageInstance = Storage();

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: picturesList,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data.length == 3) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Expanded(
                      child: Container(
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeCase(
                                                              id: widget
                                                                  .caseID)));
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
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 30);
                  },
                );
              } else {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      addPhoto(),
                      ListView.separated(
                        shrinkWrap: true,
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
                              children: [
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
                                                onPressed: () async{
                                                  await storageInstance
                                                      .deleteFileFromUrl(
                                                          snapshot.data[index]);
                                                  setState(() {});
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
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Text('hello');
            }
          },
        ),
      ),
    );
  }

  addPhoto() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Vous pouvez ajouter 3 photos maximum'),
        IconButton(
          onPressed: () async {
            await storageInstance.uploadImage(
                pathToStorage: 'cases/' + widget.caseID + '/pictures/');
            setState(() {});
          },
          icon: Icon(
            Icons.add_a_photo,
          ),
        )
      ],
    );
  }
}
