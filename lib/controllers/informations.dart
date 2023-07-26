import 'package:flutter/material.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class Informations extends StatelessWidget {
  const Informations({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Text('jello'),
    );
  }
}
