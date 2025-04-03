import 'dart:convert';

import 'package:in_out/models/pay.dart';
import 'package:in_out/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    final userLogged = await tryLoginUser();
    final user = User();

    if (userLogged != null) {
      user.email = userLogged.email;
      user.pass = userLogged.pass;
      user.lastDate = userLogged.lastDate;
      user.pays = getPays();
      await setUserAtLogin(user.toRawJson());
    }
  }

  static Future<void> setPay(String payString, String key) async {
    await _preferences!.setString("pay${User().email}$key", payString);
  }

  /// needs user in RawJson format
  static Future<void> setUserAtLogin(String userJson) async {
    await _preferences!.setString("user", userJson);
  }

  static Future<User?> tryLoginUser() async {
    final userJson = _preferences!.getString('user') ?? '';
    if (userJson.isNotEmpty) {
      final user = User.fromMap(jsonDecode(userJson));

      final lastDate = DateTime.tryParse(user.lastDate);

      if (lastDate != null) {
        if (DateTime.now().subtract(const Duration(days: 2)).isBefore(lastDate)) {
          return user;
        }
      }
    }
    return null;
  }

  static User? tryUserLocal(String mail, String pass) {
    final userJson = _preferences!.getString('user') ?? '';
    if (userJson.isEmpty) return null;

    final user = User.fromMap(jsonDecode(userJson));

    if (user.email != mail || user.pass != pass) return null;

    return user;
  }

  static List<Pay> getPays() {
    var keys = _preferences!.getKeys();
    try {
      List<Pay> pays = [];
      List<String> keysPays = [];
      var i = 0;

      for (var key in keys) {
        if (key.contains('pay${User().email}')) {
          keysPays.add(_preferences!.getString(key)!);

          if (keysPays.isNotEmpty) {
            var keyPay = Pay.fromRawJson(keysPays[i]);

            pays.add(keyPay);
            i++;
          }
        }
      }

      if (pays.length > 1) {
        pays.sort((a, b) => b.date.compareTo(a.date));
      }

      return pays.toList();
    } on Exception catch (_) {
      return [];
    }
  }

  static int getCantidad() {
    return _preferences!.getKeys().length;
  }

  static Future<void> clearAllStored() async {
    await _preferences!.clear();
  }

  static Future<void> deleteOne(String key) async {
    if (_preferences!.containsKey("pay${User().email}$key")) {
      await _preferences!.remove("pay${User().email}$key");
    }
  }
}
