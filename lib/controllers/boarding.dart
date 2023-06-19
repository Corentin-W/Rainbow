import 'package:flutter/material.dart';
import 'package:nouga/services/auth_service.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              AuthService authService = AuthService();
              authService.signOut();
            },
            child: Text('bye')),
      ),
    );
  }
}
