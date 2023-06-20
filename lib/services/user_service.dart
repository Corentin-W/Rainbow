import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<int?> checkUserEtat() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    DocumentSnapshot<Map<String, dynamic>> value =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (value.data()!['etat'] == 0) {
      return 0;
    } else if (value.data()!['etat'] == 1) {
      return 1;
    } else {
      return null;
    }
  }
}
