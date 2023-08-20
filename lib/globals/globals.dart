import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Globals {
  rainbowName({required fontSize}) {
    return Text('Rainbow',
        style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
                fontSize: fontSize.toDouble(), fontWeight: FontWeight.w800)));
  }

  getRainbowMainColor() {
    return const Color.fromARGB(175, 255, 239, 8);
  }

  getRainbowLogo({required width, required height, required bool withName}) {
    switch (withName) {
      case true:
        return Column(
          children: [
            Image.asset('assets/logos/rainbow.png',
                width: width.toDouble(), height: height.toDouble()),
            rainbowName(fontSize: 50)
          ],
        );
      case false:
        return Image.asset('assets/logos/rainbow.png',
            width: width.toDouble(), height: height.toDouble());
    }
  }

  deleteUser(email, context) {
    DocumentReference<Map<String, dynamic>> db =
        FirebaseFirestore.instance.collection('users').doc(email);
    db.delete().then((value) => Navigator.pop(context));
  }

  textWithRainbowPolice(
      {required textData,
      required size,
      required weight,
      required TextAlign align,
      Color color = Colors.black}) {
    return Text(textData,
        textAlign: align,
        style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
                fontSize: size.toDouble(), fontWeight: weight, color: color)));
  }

  signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      // Déconnectez-vous de Firebase
      await _auth.signOut();

      // Déconnectez-vous de Google Sign-In
      await _googleSignIn.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }

  // Future<Map<String, dynamic>> getAllInfosFromCase(
  //     {required String caseID}) async {
  //   final request =
  //       await FirebaseFirestore.instance.collection('cases').doc(caseID).get();
  //   final data = request.data()!;
  //   // final fieldNames = data.keys.toList();
  //   return data;
  // }

  Stream<Map<String, dynamic>> getAllInfosFromCase(
      {required String caseID}) async* {
    final request =
        FirebaseFirestore.instance.collection('cases').doc(caseID).snapshots();
    await for (final snapshot in request) {
      final data = snapshot.data()!;
      yield data;
    }
  }
}
