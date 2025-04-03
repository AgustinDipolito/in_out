import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_out/models/users.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<void> addUser(Map<String, dynamic> userJson) async {
    await db.collection("users").doc(userJson['email']).set(userJson);
  }

  Future<void> saveData(User user) async {
    if (user.email.isNotEmpty && user.pass.isNotEmpty) {
      final users = db.collection('users');

      await users.doc(user.email).update(user.toMap()).catchError(
            (onError) async => await users.doc(user.email).set(user.toMap()),
          );
    }
  }

  Future<User?> loadUser(String email, String pass) async {
    final userDoc = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .where('pass', isEqualTo: pass)
        .get();

    if (userDoc.docs.isNotEmpty) {
      final userMap = userDoc.docs.first.data();
      final user = User.fromMap(userMap);

      user.lastDate = DateTime.now().toString();
      return user;
    }
    return null;
  }
}
