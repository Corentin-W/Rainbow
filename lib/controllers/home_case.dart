import 'package:flutter/material.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';

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
  late var caseInfos = {};

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      caseInfos = await widget.globals.getAllInfosFromCase(caseID: widget.id);
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
          child: columnHomeCases(),
        ),
      ),
    );
  }

  columnHomeCases() {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            enTete(),
            SizedBox(height: 20),
            ficheInfo()
          ]),
    );
  }

  Widget enTete() {
    final prenom = caseInfos['prenom'];
    final nom = caseInfos['nom'];
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

  ficheInfo() {
    final age = caseInfos['age'];
    if (age != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
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
                  textData: 'Age :  ' + caseInfos['age'],
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
}
