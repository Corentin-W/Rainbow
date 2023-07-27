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

Future<String> uploadImage(File imageFile) async {
  try {
    // Créer une référence à Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;

    // Obtenir le nom de fichier de l'image
    String fileName = Path.basename(imageFile.path);

    // Créer une référence à l'emplacement dans le stockage Firebase
    Reference reference = storage.ref().child(fileName);

    // Commencer l'upload
    UploadTask uploadTask = reference.putFile(imageFile);

    // Attendre que l'upload se termine
    TaskSnapshot storageTaskSnapshot = await uploadTask;

    // Récupérer l'URL de téléchargement de l'image
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // Retourner l'URL de téléchargement de l'image
    return downloadUrl;
  } catch (e) {
    print('Erreur lors de l\'upload de l\'image : $e');
    return null;
  }
}
}
