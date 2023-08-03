import 'package:cloud_firestore/cloud_firestore.dart';

class DBservice {
  addEntryCase({required String caseID, required String fileNameUrl}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('cases').doc('${caseID}/').update({'photos': fileNameUrl});
  }

  addToFavorite({required String userEMAIL, required String caseID}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var userDocRef = db.collection('favorites').doc(userEMAIL);
    final datas = {caseID: caseID};
    var result = userDocRef.set(datas);
  }

  removeFromFavorite({required String userEMAIL, required String caseID})async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var userDocRef = db.collection('favorites').doc(userEMAIL);
  }
}
