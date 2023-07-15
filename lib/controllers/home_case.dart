import 'package:flutter/material.dart';

import '../globals/drawer.dart';
import '../globals/globals.dart';

class HomeCase extends StatefulWidget {
  String id;
  Globals globals = Globals();

  HomeCase({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeCase> createState() => _HomeCaseState();
}

class _HomeCaseState extends State<HomeCase> {
  late var caseInfos;

  @override
  void initState() {
    super.initState();
    caseInfos = widget.globals.getAllInfosFromCase(caseID: widget.id);
    print(caseInfos['nom']);
  }

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: columnHomeCases(),
        ),
      ),
    );
  }

  columnHomeCases() {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            enTete(),
            SizedBox(height: 20),
            ficheInfo()
          ]),
    );
  }

  enTete() {
    return widget.globals.textWithRainbowPolice(
        textData: 'testtttt',
        align: TextAlign.center,
        size: 20,
        weight: FontWeight.w600);
  }

  ficheInfo() {
    return Text('fiche info');
  }
}
