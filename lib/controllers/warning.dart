import 'package:flutter/material.dart';
import 'package:nouga/controllers/new_case.dart';

import '../globals/globals.dart';

class Warning extends StatelessWidget {
  const Warning({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addButton',
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                logo(),
                textWarning(),
                buttonWarning(context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  logo() {
    Globals globals = Globals();

    return globals.getRainbowLogo(height: 200, width: 200, withName: false);
  }

  textWarning() {
    Globals globals = Globals();
    return globals.textWithRainbowPolice(
        textData:
            "Vos etes sur le point de déclarer une disparition et donc d'ouvrir un Case. Il est important de savoir que les utilisateurs de Rainbow, dans un rayon proche de la disparition signalee, seront avertis.Toute déclaration trompeuse où fausse est interdite.Une vérification sera faite dès l'ouverture du Case.",
        size: 20,
        align: TextAlign.center,
        weight: FontWeight.w800);
  }

  buttonWarning({required context}) {
    return Positioned(
        top: 20,
        child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewCase()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: const Color.fromARGB(255, 46, 56, 232),
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 150,
                    child: const ListTile(
                      title: Center(
                        child: Text(
                          "J'ai compris",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      dense: true,
                    )),
              ),
            )));
  }
}
