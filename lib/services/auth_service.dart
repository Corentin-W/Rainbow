import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign in
  signInWithGoogle() async {
    // begin sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth detail from request
    final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

    // create new credential for user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

    // Firebase sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
    // finally lets sign in

    // _googleSignIn = GoogleSignIn(
    //   scopes: [
    //     'email',
    //     'https://www.googleapis.com/auth/contacts.readonly',
    //   ],
    // );
    // try {
    //   await _googleSignIn.signIn();
    // } catch (error) {
    //   print(error);
    // }
  }
}
