// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';
import '../models/storage/storage.dart';

class PicturesCase extends StatefulWidget {
  String caseID;
  PicturesCase({
    Key? key,
    required this.caseID,
  }) : super(key: key);

  @override
  State<PicturesCase> createState() => _PicturesCaseState();
}

class _PicturesCaseState extends State<PicturesCase> {
  @override
  Widget build(BuildContext context) {
    Storage storageInstance = Storage();
    Future<dynamic> picturesList =
        storageInstance.getPicturesFromCase(caseID: widget.caseID);
    Globals globals = Globals();
    return Scaffold(
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
      body: FutureBuilder(
        future: picturesList,
        builder: (context, snapshot) {
          print('fefefeff');
          print(snapshot);
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              print(snapshot.data[index]);
              return Image.network(snapshot.data[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }
}
