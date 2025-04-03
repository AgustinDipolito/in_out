import 'dart:convert';

import 'package:in_out/models/pay.dart';

class User {
  static final User _singleton =
      User._internal('', '', [], DateTime.now().toIso8601String());
  String email = '', pass = '', lastDate = '';

  List<Pay> pays = [];

  factory User() {
    return _singleton;
  }

  User._internal(email, pass, pays, lastDate);

  String toRawJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> map) {
    List<Pay> onlinePays = [];
    if (map['jsonPays'] != '') {
      (map['jsonPays'] as String).split('},').forEach((element) {
        var ele = element.replaceAll('}', '');
        if (ele.contains('name')) onlinePays.add(Pay.fromRawJson('$ele}'));
      });
    }

    var u = User();
    u.email = map['email'];
    u.pass = map['pass'];
    u.pays = onlinePays;
    u.lastDate = map['lastDate'] ?? '';

    return u;
  }

  Map<String, dynamic> toMap() {
    String jsonPays = '';

    for (var element in pays) {
      jsonPays += '${element.toRawJson()},';
    }
    return {
      'email': email,
      'pass': pass,
      'lastDate': lastDate,
      'jsonPays': jsonPays,
    };
  }

  User clean() {
    final userClean = User();

    userClean.email = '';
    userClean.pass = '';
    userClean.lastDate = DateTime(2000).toString();
    userClean.pays = [];

    return userClean;
  }
}
