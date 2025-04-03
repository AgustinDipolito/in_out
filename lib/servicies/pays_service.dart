import 'dart:math';

import 'package:flutter/material.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/models/users.dart';
import 'package:in_out/servicies/firebase/firestore_service.dart';
import 'package:in_out/servicies/shared_preferences_services.dart';

class PaysService with ChangeNotifier {
  List<Pay> get history => getHistory();
  set history(List hist) => hist;

  List<Pay> getHistory() {
    if (User().pays.isEmpty) {
      var pays = UserPreferences.getPays()..sort((a, b) => b.date.compareTo(a.date));

      if (pays.isNotEmpty) {
        User().pays = pays;

        // _sendToFirestore();
      }
      return pays;
    } else {
      history = User().pays;
      return User().pays;
    }
  }

  List<Pay> getInsHistory(DateTime dateLimit) {
    return history
        .where((element) => element.isIncome && element.date.isAfter(dateLimit))
        .toList();
  }

  List<Pay> getOutsHistory(DateTime dateLimit) {
    return history
        .where((element) => !element.isIncome && element.date.isAfter(dateLimit))
        .toList();
  }

  int getOuts(DateTime limitDate) {
    var outs = 0;

    for (var element in getOutsHistory(limitDate)) {
      outs += element.value;
    }
    return outs;
  }

  int getIns(DateTime limitDate) {
    var ins = 0;
    for (var element in getInsHistory(limitDate)) {
      ins += element.value;
    }
    return ins;
  }

  Future<void> newPay(Pay pay) async {
    final timeOffset = Random().nextInt(1000);
    final newDate = DateTime.now().add(Duration(milliseconds: timeOffset));

    pay = pay.copyWith(date: newDate);

    history.insert(0, pay);

    await UserPreferences.setPay(pay.toRawJson(), pay.date.toIso8601String());

    _setHistorySorted();
    _sendToFirestore();

    notifyListeners();
  }

  void clearAll() {
    history.clear();
    UserPreferences.clearAllStored();
    _setHistorySorted();

    notifyListeners();
  }

  Future<void> deleteOne(Pay pay) async {
    history.removeWhere((item) => item.name == pay.name && item.date == pay.date);

    await UserPreferences.deleteOne(pay.date.toIso8601String());

    _setHistorySorted();
    _sendToFirestore();

    notifyListeners();
  }

  void _setHistorySorted() {
    history = UserPreferences.getPays()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _sendToFirestore() async {
    await FirestoreService().saveData(User());
  }
}
