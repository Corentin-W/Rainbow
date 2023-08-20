import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class SettingsPage extends StatefulWidget {
  final Globals globals = Globals();
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            widget.globals
                .getRainbowLogo(height: 80, width: 100, withName: false),
            const SizedBox(height: 10)
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: settingList(),
    );
  }

  settingList() {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [deleteProfil()]));
  }

  deleteProfil() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 93, 162, 219), elevation: 2),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Attention'),
                content: const Text(
                    'Toutes vos donnees, ainsi que vos cases seront supprimees'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? userEMAIL = prefs.getString('userEmail') ?? "";
                      if (userEMAIL != "") {
                        DocumentReference<Map<String, dynamic>> db =
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userEMAIL);
                        db.delete().then((value) => widget.globals.signOut());
                      }
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            },
          );
        },
        child: widget.globals.textWithRainbowPolice(
            textData: 'Supprimer mon compte',
            align: TextAlign.start,
            weight: FontWeight.w300,
            color: Colors.black,
            size: 15));
  }
}
