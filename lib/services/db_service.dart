import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBservice {

  addEntryCase({required String caseID, required String fileNameUrl}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('cases').doc('${caseID}/').update({'photos': fileNameUrl});
  }
}
