import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String userID = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userId') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
      print('two');
          print(userID);

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
          print(snapshot);
          return columnHomeCases(infosCase: snapshot);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  columnHomeCases({required infosCase}) {
    return Column(children: [
      SizedBox(height: 20),
      enTete(infosCases: infosCase),
      SizedBox(height: 5),
      sousPartie(infosCases: infosCase),
      SizedBox(height: 20),
      carouselWidget(infosCases: infosCase),
      SizedBox(height: 20),
      actionsButtons(),
      SizedBox(height: 20),
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

  carouselWidget({required infosCases}) {
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: widget._controller,
          options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  widget._current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => widget._controller.animateToPage(entry.key),
              child: Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Color.fromARGB(175, 255, 239, 8))
                          .withOpacity(
                              widget._current == entry.key ? 0.9 : 0.4))),
            );
          }).toList(),
        )
      ],
    );
  }

  final List<String> imgList = [
    'https://hips.hearstapps.com/hmg-prod/images/summer-instagram-captions-1648142279.png',
    'https://hips.hearstapps.com/hmg-prod/images/summer-instagram-captions-1648142279.png',
    'https://hips.hearstapps.com/hmg-prod/images/best-summer-instagram-captions-1619209703.jpg',
  ];

  late final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(1.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  )),
            ),
          ))
      .toList();

  actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.small(
          backgroundColor: const Color.fromARGB(175, 255, 239, 8),
          elevation: 3,
          onPressed: () {
            print('here');
          },
          child: Icon(Icons.message),
        ),
        SizedBox(width: 10),
        FloatingActionButton.small(
          backgroundColor: const Color.fromARGB(175, 255, 239, 8),
          elevation: 3,
          onPressed: () {
            print('here');
          },
          child: Icon(Icons.favorite),
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
}
