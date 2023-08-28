import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  Future<User?> getUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  // Google Sign in
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);
    String? email = gUser?.email;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final docRef = db.collection('users').doc(email).get();
    docRef.then((DocumentSnapshot doc) {
      if (doc.data() == null) {
        db
            .collection('users')
            .doc(email)
            .set({'email': email, 'etat': 0}).onError(
                (e, _) => print("Error writing document: $e"));
      }
    });
    // Firebase sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
