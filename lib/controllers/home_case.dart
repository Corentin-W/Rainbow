import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';

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
          print(snapshot);
          print('ici');
          print(snapshot.data!['prenom']);
          return columnHomeCases(infosCase: snapshot);
          // return Text('zon');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  columnHomeCases({required infosCase}) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            enTete(infosCases: infosCase),
            SizedBox(height: 20),
            carouselWidget()
            // ficheInfo()
          ]),
    );
  }

  Widget enTete({required infosCases}) {
    final prenom = infosCases.data!['prenom'];
    print(prenom);
    final nom = infosCases.data!['nom'];
    print(nom);
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
    final age = infosCases['age'];
    if (age != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://www.missnumerique.com/blog/wp-content/uploads/reussir-sa-photo-de-profil-michael-dam.jpg'))),
            width: 150,
            height: 170,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.globals.textWithRainbowPolice(
                  textData: 'Age :  ' + infosCases['age'],
                  align: TextAlign.center,
                  size: 20,
                  weight: FontWeight.w600)
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }

  carouselWidget() {
    
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
                          .withOpacity(widget._current == entry.key ? 0.9 : 0.4))),
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
}
