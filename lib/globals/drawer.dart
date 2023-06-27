import 'package:flutter/material.dart';
import '../controllers/home.dart';
import '../controllers/informations.dart';

class DrawerGlobal extends StatelessWidget {
  const DrawerGlobal({super.key, required BuildContext contextFrom});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.plus_one,
            ),
            title: const Text('Creer un case'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite_border,
            ),
            title: const Text('Cases suivis'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
            ),
            title: const Text('Informations'),
            onTap: () {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Informations()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.policy,
            ),
            title: const Text('Politique generale'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.contacts,
            ),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.coffee,
            ),
            title: const Text('Coffee ?'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
