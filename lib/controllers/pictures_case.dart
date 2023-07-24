import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';

class PicturesCase extends StatefulWidget {
  late String caseID;

  PicturesCase({required caseID, super.key});

  @override
  State<PicturesCase> createState() => _PicturesCaseState();
}

class _PicturesCaseState extends State<PicturesCase> {
  // final storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    Globals globals = Globals();
    return  Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              globals.getRainbowLogo(height: 80, width: 100, withName: false),
              const SizedBox(height: 10)
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        drawer: DrawerGlobal(contextFrom: context),
        body: Text('center'),
    );
  }
}
