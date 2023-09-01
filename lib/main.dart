import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:nouga/models/person.dart';
import 'package:nouga/services/auth_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controllers/boarding.dart';
import 'controllers/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nouga/boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  AuthService authService = AuthService();
  User? user = await authService.getUser();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', user?.uid ?? '');
  prefs.setString('userEmail', user?.email ?? '');

  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  var openBox = await Hive.openBox<Person>('personBox');
  var myOpenBox = await Hive.openBox('testbox');
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('fr')],
      debugShowCheckedModeBanner: false,
      title: 'Rainbow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // if (FirebaseAuth.instance.currentUser == null) {
    //   AuthService instanceSignOut = AuthService();
    //   instanceSignOut.signOut();
    // }
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const Boarding();
          } else {
            return const Login();
          }
        });
  }
}
