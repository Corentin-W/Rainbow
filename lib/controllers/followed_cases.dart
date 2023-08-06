// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class FollowedCases extends StatefulWidget {
  String userEmail;
  FollowedCases({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<FollowedCases> createState() => _FollowedCasesState();
}

class _FollowedCasesState extends State<FollowedCases> {
  Globals globals = Globals();
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: displayFavList(),
      ),
    );
  }

  Future<Map> getFavListFromUser({required String userEMAIL}) async {
    Map favList = {};
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> userList =
        await db.collection('favorites').doc(userEMAIL).get();
    favList = userList.exists ? userList.data()! : {};
    return favList;
  }

  displayFavList() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return FutureBuilder(
  future: db.collection('favorites').doc(widget.userEmail).get(), 
  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) { 
    if (snapshot.hasError) {
      return Text("Something went wrong");
    }

    if (snapshot.hasData) { // 👈
      snapshot.data!.forEach((e) {
        print(e.data.toString());
        print(e.data.runtimeType);
      });
    }

    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: globals.getRainbowMainColor(),
                        size: 100,
                      ),
                    );;
  },
);
  }
}
