import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
}
