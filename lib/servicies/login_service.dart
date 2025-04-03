import 'package:flutter/material.dart';
import 'package:in_out/models/users.dart';
import 'package:in_out/servicies/firebase/firestore_service.dart';
import 'package:in_out/servicies/shared_preferences_services.dart';

class LoginService with ChangeNotifier {
  late User user;

  Future<void> createGuest() async {
    final newUser = User();

    newUser.email = 'guest';
    newUser.pass = 'guest';
    newUser.pays = [];
    newUser.lastDate = DateTime.now().toString();

    await UserPreferences.setUserAtLogin(newUser.toRawJson());
  }

  Future<bool> addUser(String email, String pass) async {
    final usersDoc = await FirestoreService()
        .db
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (usersDoc.docs.isEmpty) {
      final newUser = User();

      newUser.email = email;
      newUser.pass = pass;
      newUser.pays = [];
      newUser.lastDate = DateTime.now().toString();

      await UserPreferences.setUserAtLogin(newUser.toRawJson());
      await FirestoreService().addUser(newUser.toMap());
      notifyListeners();
      return true;
    }
    notifyListeners();

    return false;
  }

  Future<bool> logIn(String email, String pass) async {
    User? localUSer;
    if (email != 'guest') {
      localUSer = UserPreferences.tryUserLocal(email, pass);
    }

    if (localUSer != null) {
      localUSer.lastDate = DateTime.now().toString();
      await UserPreferences.setUserAtLogin(localUSer.toRawJson());

      notifyListeners();
      return true;
    } else {
      if (email != 'guest') {
        final firestoreUser = await FirestoreService().loadUser(email, pass);

        if (firestoreUser != null) {
          await UserPreferences.setUserAtLogin(firestoreUser.toRawJson());

          notifyListeners();
          return true;
        }
      }
    }
    notifyListeners();

    return false;
  }

  Future<void> logOut() async {
    await UserPreferences.setUserAtLogin("");
    notifyListeners();
  }
}
