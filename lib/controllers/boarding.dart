import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home.dart';
import 'package:nouga/globals/globals.dart';
import 'package:nouga/services/auth_service.dart';
import 'package:nouga/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserService userService = UserService();
    String googleApikey = "";
    GoogleMapController? mapController; //contrller for Google map
    CameraPosition? cameraPosition;
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
                return Home();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
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
        padding: EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Center(
          child: Column(children: [
            globals.getRainbowLogo(height: 125, width: 125, withName: true),
            SizedBox(
              height: 30,
            ),
            globals.textWithRainbowPolice(
                size: 18,
                align: TextAlign.center,
                weight: FontWeight.w400,
                textData:
                    "Bienvenue sur Rainbow, pour commencer nous allons vous demander un peu plus d'informations"),
            inputs()
          ]),
        ),
      ),
    );
  }

  inputs() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(height: 30),
          pseudoInput(),
          googlePlacesInput(),
          validateButton()
        ],
      ),
    );
  }

  pseudoInput() {
    return Positioned(
      top: 10,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 40,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, top: 10),
                hintText: pseudo,
                suffixIcon: Icon(Icons.account_circle),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  googlePlacesInput() {
    String googleApikey = "AIzaSyAEeRnZZsAmcU4pgQQSDDKImPzmtW-xwKQ";
    GoogleMapController? mapController; //contrller for Google map
    CameraPosition? cameraPosition;
    // LatLng startLocation = LatLng(27.6602292, 85.308027);

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
                    print(err);
                  });

              if (place != null) {
                setState(() {
                  location = "";
                  location = place.description.toString();
                  print(location);
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    )),
              ),
            )));
  }

  validateButton() {
    return Positioned(
        top: 20,
        child: InkWell(
            onTap: () {
              print(location);
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                color: Color.fromARGB(255, 48, 134, 205),
                child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
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
}
