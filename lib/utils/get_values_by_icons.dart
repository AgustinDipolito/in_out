import 'package:flutter/material.dart';
import '../models/pay.dart';

List<double> getValuesByIcons(List<Pay> outs, List<IconData> icons) {
  List<double> results = List.generate(icons.length, (index) => 0);

  var i = 0;

  while (i < icons.length) {
    var temp =
        outs.where((element) => element.type == PayType.values[i]).toList();

    for (var e in temp) {
      results[i] += e.value;
    }
    i++;
  }

  return results;
}
