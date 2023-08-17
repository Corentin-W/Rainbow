// ignore_for_file: unused_import

// import 'dart:js_interop';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/pictures_case.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';
import '../models/storage/storage.dart';
import '../services/db_service.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:photo_view/photo_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeCase extends StatefulWidget {
  String id;
  Globals globals = Globals();
  HomeCase({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeCase> createState() => _HomeCaseState();
}

class _HomeCaseState extends State<HomeCase> {
  late SharedPreferences prefs;
  String userEMAIL = "";
  bool isFavorite = false;
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
    checkIsFavorite(userID: userEMAIL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            widget.globals
                .getRainbowLogo(height: 80, width: 100, withName: false),
            const SizedBox(height: 10)
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: streamPage(),
        ),
      ),
    );
  }

  streamPage() {
    return StreamBuilder(
      stream: widget.globals.getAllInfosFromCase(caseID: widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return columnHomeCases(infosCase: snapshot);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  columnHomeCases({required infosCase}) {
    return Column(children: [
      const SizedBox(height: 20),
      enTete(infosCases: infosCase),
      const SizedBox(height: 5),
      sousPartie(infosCases: infosCase),
      const SizedBox(height: 20),
      photoWidget(infosCases: infosCase),
      const SizedBox(height: 20),
      actionsButtons(caseInfos: infosCase),
      const SizedBox(height: 20),
      ficheInfo(infosCases: infosCase)
    ]);
  }

  Widget enTete({required infosCases}) {
    final prenom = infosCases.data!['prenom'];
    final nom = infosCases.data!['nom'];
    if (prenom != null && nom != null) {
      return widget.globals.textWithRainbowPolice(
          textData: prenom + ' ' + nom,
          align: TextAlign.center,
          size: 20,
          weight: FontWeight.w600);
    } else {
      return Container();
    }
  }

  ficheInfo({required infosCases}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        widget.globals.textWithRainbowPolice(
            textData: '${'Age :  ' + infosCases.data!['age']} ans',
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600),
        widget.globals.textWithRainbowPolice(
            textData: 'Cheveux :  ' + infosCases.data!['cheveux'],
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600),
        widget.globals.textWithRainbowPolice(
            textData: '${'Taille :  ' + infosCases.data!['taille']} cm',
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600),
        widget.globals.textWithRainbowPolice(
            textData:
                'Vetements :  ' + infosCases.data!['description_vetements'],
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600)
      ],
    );
  }

  actionsButtons({required caseInfos}) {
    String userOwnerCase = "";
    if (caseInfos.data['user_email'] != null) {
      userOwnerCase = caseInfos.data['user_email'];
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userOwnerCase == userEMAIL) ...[
              if (caseInfos.data['photos'] == null) ...[
                FloatingActionButton.small(
                  heroTag: 'pictures',
                  backgroundColor: const Color.fromARGB(175, 255, 239, 8),
                  elevation: 3,
                  onPressed: () async {
                    var loadingAnimation = Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: widget.globals.getRainbowMainColor(),
                        size: 100,
                      ),
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: loadingAnimation,
                        );
                      },
                    );
                    Storage storageInstance = Storage();

                    String? isUploaded = await storageInstance.uploadImage(
                        pathToStorage: 'cases/${widget.id}/pictures/');
                    if (isUploaded != 'error') {
                      DBservice addEntryDocument = DBservice();
                      if (isUploaded != null) {
                        // await storageInstance.deleteFileFromUrl(
                        //     caseID: widget.id,
                        //     downloadUrl: caseInfos.data['photos']);
                        addEntryDocument.addEntryCase(
                            caseID: widget.id, fileNameUrl: isUploaded);
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(Icons.photo_camera),
                ),
                const SizedBox(width: 10),
                widget.globals.textWithRainbowPolice(
                    align: TextAlign.end,
                    size: 15,
                    weight: FontWeight.w600,
                    color: Colors.black,
                    textData: 'Ajouter une photo')
              ] else ...[
                FloatingActionButton.small(
                  heroTag: 'picture',
                  backgroundColor: const Color.fromARGB(175, 255, 239, 8),
                  elevation: 3,
                  onPressed: () async {
                    Storage storageInstance = Storage();
                    if (caseInfos.data['photos'] != null) {
                      await storageInstance.deleteFileFromUrl(
                          caseID: widget.id,
                          downloadUrl: caseInfos.data['photos']);
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.delete_outline),
                ),
                const SizedBox(width: 10),
                widget.globals.textWithRainbowPolice(
                    align: TextAlign.end,
                    size: 15,
                    weight: FontWeight.w600,
                    color: Colors.black,
                    textData: 'Supprimer la photo')
              ],
            ],
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.small(
              heroTag: 'messages',
              backgroundColor: const Color.fromARGB(175, 255, 239, 8),
              elevation: 3,
              onPressed: () {},
              child: const Icon(Icons.message),
            ),
            const SizedBox(width: 10),
            widget.globals.textWithRainbowPolice(
                align: TextAlign.end,
                size: 15,
                weight: FontWeight.w600,
                color: Colors.black,
                textData: 'Acceder aux messages de ce case')
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isFavorite) ...[
              FloatingActionButton.small(
                heroTag: 'favorite',
                backgroundColor: const Color.fromARGB(175, 255, 239, 8),
                elevation: 3,
                onPressed: () async {
                  DBservice dbINSTANCE = DBservice();
                  await dbINSTANCE.removeFromFavorite(
                      userEMAIL: userEMAIL, caseID: widget.id);
                  setState(() {
                    isFavorite = false;
                  });
                },
                child: const Icon(Icons.favorite),
              ),
              const SizedBox(width: 10),
              widget.globals.textWithRainbowPolice(
                  align: TextAlign.end,
                  size: 15,
                  weight: FontWeight.w600,
                  color: Colors.black,
                  textData: 'Retirer de vos cases enregistrés')
            ] else ...[
              FloatingActionButton.small(
                heroTag: 'favorite',
                backgroundColor: const Color.fromARGB(175, 255, 239, 8),
                elevation: 3,
                onPressed: () async {
                  DBservice dbINSTANCE = DBservice();
                  await dbINSTANCE.addToFavorite(
                      userEMAIL: userEMAIL, caseID: widget.id);
                  setState(() {
                    isFavorite = true;
                  });
                },
                child: const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 10),
              widget.globals.textWithRainbowPolice(
                  align: TextAlign.end,
                  size: 15,
                  weight: FontWeight.w600,
                  color: Colors.black,
                  textData: 'Ajouter à vos cases enregistrés')
            ],
            if (userOwnerCase == userEMAIL) ...[
              FloatingActionButton.small(
                heroTag: 'close',
                backgroundColor: const Color.fromARGB(175, 255, 239, 8),
                elevation: 3,
                onPressed: () async {
                  DBservice dbINSTANCE = DBservice();
                  await dbINSTANCE.addToFavorite(
                      userEMAIL: userEMAIL, caseID: widget.id);
                  setState(() {
                    isFavorite = true;
                  });
                },
                child: const Icon(Icons.check_box),
              ),
              const SizedBox(width: 10),
              widget.globals.textWithRainbowPolice(
                  align: TextAlign.end,
                  size: 15,
                  weight: FontWeight.w600,
                  color: Colors.black,
                  textData: 'Cloturer le case')
            ]
          ],
        )
      ],
    );
  }

  sousPartie({required infosCases}) {
    DateTime date = infosCases.data!['date'].toDate();
    Duration difference = DateTime.now().difference(date);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    final localisation = infosCases.data!['localisation'];
    return widget.globals.textWithRainbowPolice(
        textData: 'Disparition depuis $days jour(s) et $hours heure(s), a ' +
            localisation,
        align: TextAlign.center,
        size: 12,
        weight: FontWeight.w400);
  }

  photoWidget({required infosCases}) {
    if (infosCases.data!['photos'] != null) {
      return SizedBox(
        height: 300,
        width: 300,
        child: PhotoView(
          imageProvider: NetworkImage(infosCases.data!['photos']),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        ),
      );
    } else {
      return Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(dotenv.env['DEFAULT_PATH_IMAGE']!),
                fit: BoxFit.contain)),
      );
    }
  }

  checkIsFavorite({required String userID}) async {
    if (userID != "") {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot doc = await db.collection('favorites').doc(userID).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data?[widget.id] == widget.id) {
          setState(() {
            isFavorite = true;
          });
        } else {
          setState(() {
            isFavorite = false;
          });
        }
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    } else {
      setState(() {
        isFavorite = false;
      });
    }
  }
}



  // carouselWidget({required infosCases}) {
  //   return Column(
  //     children: [
  //       CarouselSlider(
  //         items: imageSliders,
  //         carouselController: widget._controller,
  //         options: CarouselOptions(
  //             autoPlay: false,
  //             enlargeCenterPage: true,
  //             aspectRatio: 1,
  //             onPageChanged: (index, reason) {
  //               setState(() {
  //                 widget._current = index;
  //               });
  //             }),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: imgList.asMap().entries.map((entry) {
  //           return GestureDetector(
  //             onTap: () => widget._controller.animateToPage(entry.key),
  //             child: Container(
  //                 width: 12,
  //                 height: 12,
  //                 margin: const EdgeInsets.symmetric(
  //                     vertical: 8.0, horizontal: 4.0),
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: (Theme.of(context).brightness == Brightness.dark
  //                             ? const Color.fromARGB(255, 0, 0, 0)
  //                             : const Color.fromARGB(175, 255, 239, 8))
  //                         .withOpacity(
  //                             widget._current == entry.key ? 0.9 : 0.4))),
  //           );
  //         }).toList(),
  //       )
  //     ],
  //   );
  // }

    // final List<String> imgList = [
  //   'https://hips.hearstapps.com/hmg-prod/images/summer-instagram-captions-1648142279.png',
  //   'https://hips.hearstapps.com/hmg-prod/images/summer-instagram-captions-1648142279.png',
  //   'https://hips.hearstapps.com/hmg-prod/images/best-summer-instagram-captions-1619209703.jpg',
  // ];

  // late final List<Widget> imageSliders = imgList
  //     .map((item) => Container(
  //           child: Container(
  //             margin: const EdgeInsets.all(1.0),
  //             child: ClipRRect(
  //                 borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  //                 child: Stack(
  //                   children: <Widget>[
  //                     Image.network(item, fit: BoxFit.cover, width: 1000.0),
  //                   ],
  //                 )),
  //           ),
  //         ))
  //     .toList();
