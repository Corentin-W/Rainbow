import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nouga/services/db_service.dart';
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
  Storage storageInstance = Storage();
  Globals globals = Globals();

  @override
  Widget build(BuildContext context) {
    // Future<dynamic> picturesList =
    //     storageInstance.getPicturesFromCase(caseID: widget.caseID);
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
        child: buildStreamBuilder(),
      ),
    );
  }

  addPhoto() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text('Vous pouvez ajouter 3 photos maximum'),
        IconButton(
          onPressed: () async {
            String isUploaded = await storageInstance.uploadImage(
                pathToStorage: 'cases/${widget.caseID}/pictures/');
            if (isUploaded != 'error') {
              DBservice addEntryDocument = DBservice();
              addEntryDocument.addEntryCase(
                  caseID: widget.caseID, fileNameUrl: isUploaded);
              setState(() {});
            }
          },
          icon: const Icon(
            Icons.add_a_photo,
          ),
        )
      ],
    );
  }

  StreamBuilder<ListResult> buildStreamBuilder() {
    return StreamBuilder<ListResult>(
      stream: FirebaseStorage.instance
          .ref()
          .child('cases/${widget.caseID}/pictures/')
          .listAll()
          .asStream(),
      builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
        if (snapshot.hasData) {
          // If there are less than 3 images
          return Expanded(
            child: Column(
              children: [
                if (snapshot.data!.items.isEmpty) ...[addPhoto()],
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Reference ref = snapshot.data!.items[index];
                    return FutureBuilder(
                      future: ref.getDownloadURL(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> urlSnapshot) {
                        if (urlSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingAnimationWidget.inkDrop(
                            color: Colors.black,
                            size: 200,
                          );
                        } else if (urlSnapshot.hasError) {
                          return const Text('Error loading image');
                        } else {
                          return Container(
                            width: 150, // Adjust the width as needed
                            height: 300, // Adjust the height as needed
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(urlSnapshot.data!),
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
                                            title: const Text('Suppression'),
                                            content: const Text(
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
                                                onPressed: () async {
                                                  await storageInstance
                                                      .deleteFileFromUrl(
                                                          downloadUrl:
                                                              urlSnapshot.data!,
                                                          caseID:
                                                              widget.caseID);
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PicturesCase(
                                                                  caseID: widget
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
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return LoadingAnimationWidget.inkDrop(
            color: Colors.black,
            size: 200,
          );
        }
      },
    );
  }
}
