import 'package:flutter/cupertino.dart';

class ConfigService with ChangeNotifier {
  DateTime dateLimit = DateTime(
    DateTime.now().year - 1,
    DateTime.now().month,
    DateTime.now().day - 1,
  );
  final periods = ['7d', '1M', '6M', '1Y'];

  bool isIncome = false;
  int year = DateTime.now().year;

  final datesLimits = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 8),
    DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day - 1),
    DateTime(DateTime.now().year, DateTime.now().month - 6, DateTime.now().day - 1),
    DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day - 1),
  ];

  newPeriod(String duration) {
    dateLimit = getDatesLimits(duration);
    notifyListeners();
  }

  DateTime getDatesLimits(String duration) {
    var durationsLimits = Map.fromIterables(periods, datesLimits);
    return durationsLimits[duration] ?? dateLimit;
  }

  String getPeriodLimit(DateTime date) {
    return periods[datesLimits.indexOf(date)];
  }

  void switchType() {
    isIncome = !isIncome;
    notifyListeners();
  }

  void changeYear(int y) {
    year = y;
    notifyListeners();
  }
}
