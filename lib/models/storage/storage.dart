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
      String downloadURL = await item.getDownloadURL();
      returnList.add(downloadURL);
    }
    print(returnList);
    return returnList;
  }

  Future<void> deleteFileFromUrl(String downloadUrl) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // Crée une instance de FirebaseStorage pour interagir avec le stockage Firebase.

    // Convertir l'URL de téléchargement en une référence de stockage
    Reference ref = storage.refFromURL(downloadUrl);
    // Utilise la méthode refFromURL() pour obtenir la référence du fichier dans le stockage Firebase
    // à partir de l'URL de téléchargement que vous avez fournie.

    // Appeler la fonction pour supprimer le fichier
    await ref.delete();
    // Utilise la méthode delete() sur la référence pour supprimer le fichier correspondant
}
}
