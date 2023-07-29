import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

class Storage {
  getPicturesFromCase({required caseID}) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("cases/" + caseID + "/pictures/");
    final listResult = await storageRef.listAll();
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

  uploadImage({required pathToStorage}) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    } else {
      final File selectedImage = File(image.path);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();

      // Get the file name and extension.
      final fileName = p.basename(selectedImage.path);

      // Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child(pathToStorage + fileName);

      try {
        mountainsRef.putFile(selectedImage);
        return true;
      } catch (e) {
        print(e);
      }
    }
  }
}
