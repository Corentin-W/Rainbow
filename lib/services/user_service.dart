// import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<Map<String, dynamic>?> checkUserEtat() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    DocumentSnapshot<Map<String, dynamic>> value =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (value.data() == null) {
      return null;
    } else if (value.data() != null) {
      return value.data();
    } else {
      return null;
    }
  }

  Future<String?> getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return "";
    }
  }
}
