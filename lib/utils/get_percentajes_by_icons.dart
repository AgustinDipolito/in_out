List<int> getPercetajesByIcons(List<double> values) {
    List<int> percentajes = [];

    final total = values.reduce((value, element) => value + element);

    for (var element in values) {
      if (element == 0) {
        percentajes.add(0);
      } else {
        percentajes.add(element * 100 ~/ total);
      }
    }
    return percentajes;
  }