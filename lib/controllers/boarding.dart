// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nouga/controllers/home.dart';
import 'package:nouga/globals/globals.dart';
import 'package:nouga/services/user_service.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  String location = "Rechercher votre ville";
  String pseudo = "Choisir un pseudo";
  final pseudoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserService userService = UserService();
    String? googleApikey = dotenv.env['APIKEY_GOOGLEPLACES'];
    GoogleMapController? mapController; //contrller for Google map
    // CameraPosition? cameraPosition;
    // LatLng startLocation = LatLng(27.6602292, 85.308027);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: userService.checkUserEtat(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['etat'] == 0) {
                return firstBoardingPage(
                    email: snapshot.data['email'],
                    screenWidth: width,
                    screenHeight: height);
              } else {
                return const Home();
              }
            } else {
              return const Center(
                child: LoadingAnimationWidget.inkDrop(
                color: Colors.black,
                size: 200,
              );,
              );
            }
          }),
    );
  }

  Widget firstBoardingPage(
      {required email,
      required double screenWidth,
      required double screenHeight}) {
    Globals globals = Globals();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Center(
          child: Column(children: [
            globals.getRainbowLogo(height: 125, width: 125, withName: true),
            const SizedBox(
              height: 30,
            ),
            globals.textWithRainbowPolice(
                size: 18,
                align: TextAlign.center,
                weight: FontWeight.w400,
                textData:
                    "Bienvenue sur Rainbow, pour commencer nous allons vous demander un peu plus d'informations"),
            inputs(email: email)
          ]),
        ),
      ),
    );
  }

  inputs({required email}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const SizedBox(height: 30),
          pseudoInput(),
          googlePlacesInput(),
          validateButton(email: email)
        ],
      ),
    );
  }

  pseudoInput() {
    return Positioned(
      top: 10,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 40,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15, top: 10),
                hintText: pseudo,
                suffixIcon: const Icon(Icons.account_circle),
                border: InputBorder.none,
              ),
              controller: pseudoController,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  googlePlacesInput() {
    String? googleApikey = dotenv.env['APIKEY_GOOGLEPLACES'];

    return Positioned(
        //search input bar
        top: 10,
        child: InkWell(
            onTap: () async {
              var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'fr')],
                  //google_map_webservice package
                  onError: (err) {
                  });

              if (place != null) {
                setState(() {
                  location = "";
                  location = place.description.toString();
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.search),
                      dense: true,
                    )),
              ),
            )));
  }

  validateButton({required email}) {
    return Positioned(
        top: 20,
        child: InkWell(
            onTap: () {
              if (pseudoController.text == "") {
                return showAlert(context, 'pseudo.');
              }
              if (location == "Rechercher votre ville") {
                return showAlert(context, 'ville.');
              }

              final docData = {
                "pseudo": pseudoController.text,
                "city": location,
                "etat": 1
              };
              FirebaseFirestore db = FirebaseFirestore.instance;
              final etat = db.collection("users").doc(email);
              etat.update({"etat": 1}).then((value) {
                db.collection("users").doc(email).set(docData);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              }, onError: (e) => print("Error updating document $e"));
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: const Color.fromARGB(255, 48, 134, 205),
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: const ListTile(
                      title: Center(
                        child: Text(
                          'Valider',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      dense: true,
                    )),
              ),
            )));
  }

  void showAlert(BuildContext context, nomDuChamp) {
    AlertDialog alert = AlertDialog(
      title: const Text("Oups..."),
      content: Text("Veuillez remplir le champ $nomDuChamp"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
