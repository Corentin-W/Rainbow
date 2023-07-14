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

  textWithRainbowPolice({required textData, required size, required weight, required TextAlign align, Color color = Colors.black}) {
    return Text(textData, textAlign: align,
        style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
                fontSize: size.toDouble(), fontWeight: weight, color: color )));
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

  
}
