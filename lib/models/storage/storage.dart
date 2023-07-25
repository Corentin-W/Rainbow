import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  getPicturesFromCase({required caseID}) async {
    print('zeparti');
    final storageRef =
        FirebaseStorage.instance.ref().child("cases/" + caseID + "/pictures/");
    final listResult = await storageRef.listAll();
    print(listResult);
    List returnList = [];
    for (var item in listResult.items) {
      returnList.add(item.getDownloadURL());
    }
    print(returnList);
    return returnList;
  }
}
