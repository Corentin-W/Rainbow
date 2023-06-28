import 'package:flutter/material.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class NewCase extends StatefulWidget {
  const NewCase({super.key});

  @override
  State<NewCase> createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  final prenomPersonneDisparue = TextEditingController();
  final nomPersonneDisparue = TextEditingController();
  final agePersonneDisparue = TextEditingController();
  final descriptionPersonneDisparue = TextEditingController();
  Globals globals = Globals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Rainbow',
        ),
        backgroundColor: const Color.fromARGB(255, 143, 201, 238),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: form(),
    );
  }

  form() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                titleFirst(),
                const SizedBox(
                  height: 30,
                ),
                surName(),
                const SizedBox(height: 30),
                name(),
                const SizedBox(height: 30),
                age(),
                const SizedBox(height: 30),
                descriptionVetements(),
                const SizedBox(height: 30),
                validateButton(),
                const SizedBox(height: 30),
              ]),
        ),
      ),
    );
  }

  surName() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        controller: prenomPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Prenom"),
      ),
    );
  }

  name() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        controller: nomPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Nom"),
      ),
    );
  }

  age() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: agePersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Age"),
      ),
    );
  }

  descriptionVetements() {
    return Container(
      width: 300,
      height: 90,
      child: TextField(
        maxLines: 10,
        controller: descriptionPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Description vêtements"),
      ),
    );
  }

  titleFirst() {
    return globals.textWithRainbowPolice(
        textData: "Informations sur la personne recherchée",
        size: 20,
        align: TextAlign.center,
        weight: FontWeight.w600);
  }

  validateButton() {
    return Positioned(
        top: 20,
        child: InkWell(
            onTap: () {
              print('Prenom : ');
              print(prenomPersonneDisparue.text);

              print('Nom : ');
              print(nomPersonneDisparue.text);

              print('age : ');
              print(agePersonneDisparue.text);

              print('description : ');
              print(descriptionPersonneDisparue.text);
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: const Color.fromARGB(255, 46, 56, 232),
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: const ListTile(
                      title: Center(
                        child: Text(
                          'Suivant',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      dense: true,
                    )),
              ),
            )));
  }
}
