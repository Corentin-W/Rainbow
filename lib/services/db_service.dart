import 'package:cloud_firestore/cloud_firestore.dart';

class DBservice {
  addEntryCase({required String caseID, required String fileNameUrl}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('cases').doc('${caseID}/').update({'photos': fileNameUrl});
  }

  addToFavorite({required String userEMAIL, required String caseID}) async {
    print('zeparti');
    print(userEMAIL);
    print(caseID);
    FirebaseFirestore db = FirebaseFirestore.instance;
    var userDocRef = db.collection('favorites').doc(userEMAIL);

    final datas = {'wiwiiwiw': FieldValue.increment(1)};
    var result = userDocRef.add(datas).then();
    print(result);
  }
}
