import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:intl/intl.dart';
import 'package:nouga/services/user_service.dart';
import '../globals/drawer.dart';
import '../globals/globals.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_maps_webservice/places.dart';

import 'home_case.dart';

class NewCase extends StatefulWidget {
  const NewCase({super.key});

  @override
  State<NewCase> createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  final prenomPersonneDisparue = TextEditingController();
  final nomPersonneDisparue = TextEditingController();
  final agePersonneDisparue = TextEditingController();
  final descriptionPersonneDisparue = TextEditingController();
  Globals globals = Globals();
  String dropdownValueTaille = "Taille";
  String dropdownvalueCheveux = 'Couleur des cheveux';
  DateTime date = DateTime.now();
  String localisation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Rainbow',
        ),
        backgroundColor: const Color.fromARGB(255, 143, 201, 238),
      ),
      drawer: DrawerGlobal(contextFrom: context),
      body: form(),
    );
  }

  form() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  titleFirst(),
                  const SizedBox(
                    height: 30,
                  ),
                  surName(),
                  const SizedBox(height: 30),
                  name(),
                  const SizedBox(height: 30),
                  age(),
                  const SizedBox(height: 30),
                  descriptionVetements(),
                  const SizedBox(height: 30),
                  descriptionCheveux(),
                  const SizedBox(height: 30),
                  descriptionTaille(),
                  const SizedBox(height: 30),
                  descriptionDateDisparition(),
                  const SizedBox(height: 30),
                  derniereLocalisation(),
                  validateButton(),
                  const SizedBox(height: 30),
                ]),
          ),
        ),
      ),
    );
  }

  //   Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }

  validateButton() {
    return Positioned(
        top: 20,
        child: InkWell(
            onTap: () async {
              if (prenomPersonneDisparue.text == "") {
                showAlert(context, 'Prenom');
              } else if (nomPersonneDisparue.text == "") {
                showAlert(context, 'Nom');
              } else if (agePersonneDisparue.text == "") {
                showAlert(context, 'Age');
              } else if (descriptionPersonneDisparue.text == "") {
                showAlert(context, 'Description');
              } else if (dropdownValueTaille == "Taille") {
                showAlert(context, 'Taille');
              } else if (dropdownvalueCheveux == "Couleur des cheveux") {
                showAlert(context, 'Taille');
              } else if (localisation == "") {
                showAlert(context, 'Vu(e) la derniere fois q');
              }
              UserService userService = UserService();
              final userDataEmail = await userService.getCurrentUserEmail();
              final docData = {
                "prenom": prenomPersonneDisparue.text,
                "nom": nomPersonneDisparue.text,
                "age": agePersonneDisparue.text,
                "description_vetements": descriptionPersonneDisparue.text,
                "cheveux": dropdownvalueCheveux,
                "date": date,
                "taille": dropdownValueTaille,
                "localisation": localisation,
                "user_email": userDataEmail
              };
              FirebaseFirestore db = FirebaseFirestore.instance;
              final instance = db.collection("cases");
              DocumentReference docRef = await instance.add(docData);
              String docID = docRef.id;
              if (context.mounted) {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => HomeCase(id: docID)),
                );
              }

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (BuildContext context) => HomeCase(id: docID)),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: const Color.fromARGB(255, 46, 56, 232),
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: const ListTile(
                      title: Center(
                        child: Text(
                          'Suivant',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      dense: true,
                    )),
              ),
            )));
  }

  surName() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        controller: prenomPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Prenom"),
      ),
    );
  }

  name() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        controller: nomPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Nom"),
      ),
    );
  }

  age() {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: agePersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Age"),
      ),
    );
  }

  descriptionVetements() {
    return Container(
      width: 300,
      height: 90,
      child: TextField(
        maxLines: 10,
        controller: descriptionPersonneDisparue,
        autocorrect: true,
        decoration: const InputDecoration(hintText: "Description vêtements"),
      ),
    );
  }

  descriptionCheveux() {
    var items = [
      'Couleur des cheveux',
      'Bruns',
      'Blonds',
      'Noirs',
      'Roux',
      'Pas de cheveux',
    ];
    return Container(
      width: 300,
      height: 50,
      child: DropdownButton(
          isExpanded: true,
          value: dropdownvalueCheveux,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalueCheveux = newValue!;
            });
          }),
    );
  }

  descriptionTaille() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: 50,
        width: 300,
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValueTaille,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValueTaille = newValue!;
            });
          },
          items: <String>[
            'Taille',
            '91 cm',
            '92 cm',
            '93 cm',
            '94 cm',
            '95 cm',
            '96 cm',
            '97 cm',
            '98 cm',
            '99 cm',
            '100 cm',
            '101 cm',
            '102 cm',
            '103 cm',
            '104 cm',
            '105 cm',
            '106 cm',
            '107 cm',
            '108 cm',
            '109 cm',
            '110 cm',
            '111 cm',
            '112 cm',
            '113 cm',
            '114 cm',
            '115 cm',
            '116 cm',
            '117 cm',
            '118 cm',
            '119 cm',
            '120 cm',
            '121 cm',
            '122 cm',
            '123 cm',
            '124 cm',
            '125 cm',
            '126 cm',
            '127 cm',
            '128 cm',
            '129 cm',
            '130 cm',
            '131 cm',
            '132 cm',
            '133 cm',
            '134 cm',
            '135 cm',
            '136 cm',
            '137 cm',
            '138 cm',
            '139 cm',
            '140 cm',
            '141 cm',
            '142 cm',
            '143 cm',
            '144 cm',
            '145 cm',
            '146 cm',
            '147 cm',
            '148 cm',
            '149 cm',
            '150 cm',
            '151 cm',
            '152 cm',
            '153 cm',
            '154 cm',
            '155 cm',
            '156 cm',
            '157 cm',
            '158 cm',
            '159 cm',
            '160 cm',
            '161 cm',
            '162 cm',
            '163 cm',
            '164 cm',
            '165 cm',
            '166 cm',
            '167 cm',
            '168 cm',
            '169 cm',
            '170 cm',
            '171 cm',
            '172 cm',
            '173 cm',
            '174 cm',
            '175 cm',
            '176 cm',
            '177 cm',
            '178 cm',
            '179 cm',
            '180 cm',
            '181 cm',
            '182 cm',
            '183 cm',
            '184 cm',
            '185 cm',
            '186 cm',
            '187 cm',
            '188 cm',
            '189 cm',
            '190 cm',
            '191 cm',
            '192 cm',
            '193 cm',
            '194 cm',
            '195 cm',
            '196 cm',
            '197 cm',
            '198 cm',
            '199 cm',
            '200 cm',
            '201 cm',
            '202 cm',
            '203 cm',
            '204 cm',
            '205 cm',
            '206 cm',
            '207 cm',
            '208 cm',
            '209 cm',
            '210 cm',
            '211 cm',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  descriptionDateDisparition() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  locale: const Locale("fr", "FR"),
                  initialDate: date,
                  firstDate: DateTime(1995),
                  lastDate: DateTime.now());
              if (newDate != null) {
                setState(() {
                  date = newDate;
                });
              }
            },
            child: const Text('Choisir la date de disparition')),
        const SizedBox(height: 10),
        Text('Date choisie : ${date.day}/${date.month}/${date.year}'),
      ],
    );
  }

  derniereLocalisation() {
    String? googleApikey = dotenv.env['APIKEY_GOOGLEPLACES'];
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(
            onPressed: () async {
              var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'fr')],
                  //google_map_webservice package
                  onError: (err) {
                    print(err);
                  });

              if (place != null) {
                setState(() {
                  localisation = place.description.toString();
                });
              }
            },
            child: Text("Vu(e) la derniere fois a : ")),
        Text(localisation)
      ],
    );
  }

  titleFirst() {
    return globals.textWithRainbowPolice(
        textData: "Informations sur la personne recherchée",
        size: 20,
        align: TextAlign.center,
        weight: FontWeight.w600);
  }

  void showAlert(BuildContext context, nomDuChamp) {
    AlertDialog alert = AlertDialog(
      title: Text("Oups..."),
      content: Text("Veuillez remplir le champ $nomDuChamp"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
