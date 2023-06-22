import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home.dart';
import 'package:nouga/globals/globals.dart';
import 'package:nouga/services/auth_service.dart';
import 'package:nouga/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserService userService = UserService();
    return Scaffold(
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
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Center(
        child: Column(children: [
          globals.getRainbowLogo(height: 125, width: 125, withName: true),
          globals.textWithRainbowPolice(
              size: 18,
              align: TextAlign.center,
              weight: FontWeight.w400,
              textData:
                  "Bienvenue sur Rainbow, pour commencer nous allons vous demander un peu plus d'informations"),
          inputs()
        ]),
      ),
    );
  }

  inputs() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 238, 238),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Pseudo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
