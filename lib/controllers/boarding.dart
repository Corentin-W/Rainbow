import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/services/auth_service.dart';
import 'package:nouga/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    return Scaffold(
      body: FutureBuilder(
          future: userService.checkUserEtat(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              print('snapshot');
              print(snapshot.data);
              return Text('yess');
            } else {
              print('snapshotNOOOOOOO');
              print(snapshot);
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
