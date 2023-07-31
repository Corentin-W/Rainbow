// ignore_for_file: unused_import

import 'package:carousel_slider/carousel_slider.dart';
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
  final CarouselController _controller = CarouselController();
  int _current = 0;
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
            textData: 'Age :  ' + infosCases.data!['age'] + ' ans',
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600),
        widget.globals.textWithRainbowPolice(
            textData: 'Cheveux :  ' + infosCases.data!['cheveux'],
            align: TextAlign.start,
            size: 15,
            weight: FontWeight.w600),
        widget.globals.textWithRainbowPolice(
            textData: 'Taille :  ' + infosCases.data!['taille'] + ' cm',
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (userOwnerCase == userEMAIL) ...[
          FloatingActionButton.small(
            heroTag: 'pictures',
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            elevation: 3,
            onPressed: () async {
              var loadingAnimation = LoadingAnimationWidget.inkDrop(
                color: Colors.black,
                size: 200,
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
              if (caseInfos.data['photos'] != null) {
                await storageInstance.deleteFileFromUrl(
                    caseID: widget.id, downloadUrl: caseInfos.data['photos']);
              }

              String isUploaded = await storageInstance.uploadImage(
                  pathToStorage: 'cases/${widget.id}/pictures/');
              if (isUploaded != 'error') {
                print('icicicici');
                print(isUploaded);
                DBservice addEntryDocument = DBservice();
                addEntryDocument.addEntryCase(
                    caseID: widget.id, fileNameUrl: isUploaded);
                setState(() {});
              }
            },
            child: const Icon(Icons.photo_camera),
          ),
          const SizedBox(width: 10),
        ],
        FloatingActionButton.small(
          heroTag: 'messages',
          backgroundColor: const Color.fromARGB(175, 255, 239, 8),
          elevation: 3,
          onPressed: () {},
          child: const Icon(Icons.message),
        ),
        const SizedBox(width: 10),
        FloatingActionButton.small(
          heroTag: 'favorite',
          backgroundColor: const Color.fromARGB(175, 255, 239, 8),
          elevation: 3,
          onPressed: () {},
          child: const Icon(Icons.favorite),
        )
      ],
    );
  }

  sousPartie({required infosCases}) {
    DateTime date = infosCases.data!['date'].toDate();
    Duration difference = DateTime.now().difference(date);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    final localisation = infosCases.data!['localisation'];
    return widget.globals.textWithRainbowPolice(
        textData: 'Disparition depuis ' +
            days.toString() +
            ' jour(s) et ' +
            hours.toString() +
            ' heure(s), a ' +
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
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
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
