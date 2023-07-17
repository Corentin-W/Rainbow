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
}
