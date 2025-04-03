part of 'widgets.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pays = Provider.of<PaysService>(context);
    final config = Provider.of<ConfigService>(context);

    final spots = _createMonthPoints(pays, config.isIncome, config.year);
    final historySpots = _createHistoricalPoints(pays, false);
    final historySpotsIncome = _createHistoricalPoints(pays, true);
    final total = spots
        .fold<double>(0, (prev, spot) => prev + spot.y)
        .toString()
        .replaceAll(RegExp(r'(?<=\d)(?=(\d{3})+$)'), ".");

    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width - kSpace - 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpace, vertical: kSpace),
        decoration: BoxDecoration(
          borderRadius: 20.toRadio(),
          border: Border.all(color: Colors.black12),
          color: kBlueGrey,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: (pays.history.isEmpty)
            ? FittedBox(
                fit: BoxFit.fitWidth,
                child: Icon(
                  Icons.auto_graph_sharp,
                  color: kblack.withOpacity(.5),
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: MyLineChart(
                      spots: spots,
                      showNumbers: true,
                      oneInterval: DateTime.now().day < 8,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: kSpace,
                    bottom: kBigSpace,
                    right: kBigSpace,
                    child: Transform.scale(
                      alignment: Alignment.centerLeft,
                      scale: .25,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: MyLineChart(
                              spots: historySpots,
                              oneInterval: false,
                              showNumbers: false,
                              forceAsIncome: false,
                            ),
                          ),
                          Positioned.fill(
                            child: MyLineChart(
                              spots: historySpotsIncome,
                              oneInterval: false,
                              showNumbers: false,
                              forceAsIncome: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            iconSize: kLittleSpace,
                            color: kblack,
                            onPressed: () => config.changeYear(config.year - 1),
                            icon: const Icon(Icons.arrow_back_ios)),
                        Text(
                          '${config.year}',
                          style: const TextStyle(
                            color: kblack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          iconSize: kLittleSpace,
                          color: kblack,
                          onPressed: () => config.changeYear(config.year + 1),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: kLittleSpace,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: $total',
                          style: const TextStyle(
                            color: kblack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Prom: ${(double.parse(total) / DateTime.now().day).floorToDouble()} /day',
                          style: const TextStyle(
                            color: kblack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

List<FlSpot> _createHistoricalPoints(PaysService paysService, bool isIncome) {
  List<FlSpot> data = [];

  final today = DateTime.now();

  final paysSorted = paysService.history..sort((a, b) => b.date.compareTo(a.date));
  if (paysSorted.isEmpty) return data;
  var date = paysSorted.last.date;

  final totalCantDays = today.difference(date).inDays + 1;

  final pays =
      isIncome ? paysService.getInsHistory(date) : paysService.getOutsHistory(date);

  data.add(const FlSpot(0, 0));

  while (today.isAfter(date)) {
    final cantDays = today.difference(date).inDays;
    var value = 0;

    final mismoDia = pays.where((element) =>
        element.date.year == date.year &&
        element.date.month == date.month &&
        element.date.day == date.day);

    if (mismoDia.isNotEmpty) {
      value = mismoDia.fold(0, (int prev, e) => prev + e.value);

      data.add(
        FlSpot(
          totalCantDays - cantDays.toDouble(),
          value.toDouble(),
        ),
      );
    } else {
      data.add(FlSpot(totalCantDays - cantDays.toDouble(), 0));
    }

    date = date.add(const Duration(days: 1));
  }

  return data;
}

List<FlSpot> _createMonthPoints(PaysService paysService, bool isIncome, int year) {
  List<FlSpot> data = [];

  final days = List.generate(DateTime.now().day, (index) => index + 1);

  final today = DateTime.now();

  final iniMes = DateTime(year, today.month);

  final pays =
      isIncome ? paysService.getInsHistory(iniMes) : paysService.getOutsHistory(iniMes);

  pays.removeWhere((element) => element.date.year != year);

  data.add(const FlSpot(0, 0));

  for (var day in days) {
    var value = 0;
    final mismoDia = pays.where((element) => element.date.day == day);

    if (mismoDia.isNotEmpty) {
      value = mismoDia.fold(0, (int prev, e) => prev + e.value);
    }

    data.add(
      FlSpot(
        day.toDouble(),
        value.toDouble(),
      ),
    );
  }

  return data;
}
