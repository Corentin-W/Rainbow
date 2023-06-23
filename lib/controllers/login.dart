import 'package:flutter/material.dart';
import '../globals/globals.dart';
import '../services/auth_service.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loginColumnWidgets(
          screenWidth: screenWidth, screenHeight: screenHeight),
    );
  }

  loginColumnWidgets(
      {required double screenWidth, required double screenHeight}) {
    Globals globalInstance = Globals();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Logo et nom Rainbow
          globalInstance.getRainbowLogo(
              width: 250, height: 250, withName: true),

          // Inputs de login
          // loginFacebook(),
          loginGoogle()
        ],
      ),
    );
  }

  loginFacebook() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      onPressed: () async {
        signInWithFacebook();
      },
      icon: Icon(Icons.login),
      label: Text('Se connecter avec Facebook'),
    );
  }

  Future<UserCredential?> signInWithFacebook() async {
    // final  result = await FacebookAuth.instance.login();
    // if (result.status == LoginStatus.success) {
    //   // Create a credential from the access token
    //   final OAuthCredential credential =
    //       FacebookAuthProvider.credential(result.accessToken!.token);
    //   // Once signed in, return the UserCredential
    //   return await FirebaseAuth.instance.signInWithCredential(credential);
    // }
    return null;
  }

  loginGoogle() {
    return SignInButton(
      Buttons.Google,
      onPressed: () {
        AuthService().signInWithGoogle();
      },
    );
  }
}
