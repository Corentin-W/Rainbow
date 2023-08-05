// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(widget.userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: globals.getRainbowMainColor(),
                size: 100,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Text('yello');
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            print(snapshot.connectionState);
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: globals.getRainbowMainColor(),
                size: 100,
              ),
            );
          }
        },
      ),
    );
  }
}
