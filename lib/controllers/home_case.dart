// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class HomeCase extends StatefulWidget {
  String id;

  HomeCase({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeCase> createState() => _HomeCaseState();
}

class _HomeCaseState extends State<HomeCase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.id),
      ),
    );
  }
}
