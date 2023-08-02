import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> deleteFileFromUrl(
      {required String downloadUrl, required String caseID}) async {
    final fireInstance =
        FirebaseFirestore.instance.collection('cases').doc(caseID);
    final update = <String, dynamic>{'photos': FieldValue.delete()};
    fireInstance.update(update);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.refFromURL(downloadUrl);
    await ref.delete();
  }

  uploadImage({required pathToStorage}) async {
    // final fireInstance =  FirebaseFirestore.instance.collection('cases').doc(caseID);
    // final update = <String, dynamic>{'photos': FieldValue.delete()};
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
      print('1');
      try {
        print('2');
        await mountainsRef.putFile(selectedImage);
        String downloadUrl = await mountainsRef.getDownloadURL();
        print('envoiiiii');
        print(downloadUrl);
        return downloadUrl;
      } catch (e) {
        print(e);
        return 'error';
      }
    }
  }
}
