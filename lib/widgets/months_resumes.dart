import 'package:flutter/material.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/servicies/config_service.dart';
import 'package:in_out/servicies/pays_service.dart';
import 'package:in_out/utils/constants.dart';
import 'package:provider/provider.dart';

class MonthsResumes extends StatefulWidget {
  const MonthsResumes({Key? key}) : super(key: key);

  @override
  State<MonthsResumes> createState() => _MonthsResumesState();
}

class _MonthsResumesState extends State<MonthsResumes>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  int lastResult = 0;
  final List<String> months = [
    'JAN',
    'FEB',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUG',
    'SEPT',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<PaysService>(context);
    final year = Provider.of<ConfigService>(context).year;
    final outs = service.getOutsHistory(DateTime(year - 1));
    final ins = service.getInsHistory(DateTime(year - 1));

    List<int> totalInsByMonth = totalByMonth(ins, year);
    List<int> totalOutsByMonth = totalByMonth(outs, year);

    final moreThanOne = (totalInsByMonth.where((element) => element > 0).length > 1);

    return Container(
      width: MediaQuery.of(context).size.width - kSpace - 4,
      height: MediaQuery.of(context).size.height * (moreThanOne ? .16 : .1) + kSpace,
      padding: const EdgeInsets.symmetric(horizontal: kSpace, vertical: kLittleSpace),
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
      child: totalOutsByMonth.fold<int>(0, (p, e) => p + e) == 0
          ? const Center(
              child: Text(
                'Load your first Income!',
                style: TextStyle(
                  color: kblack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              itemCount: totalInsByMonth.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return _canShow(totalInsByMonth[index], totalOutsByMonth[index], index)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: kLittleSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                months[index],
                                style: const TextStyle(
                                  color: kblack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            ...List.generate(
                              2,
                              (i) {
                                var result = i == 0
                                    ? totalInsByMonth[index]
                                    : totalOutsByMonth[index];

                                Animation<int> intTween = IntTween(
                                  begin: lastResult,
                                  end: result,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.easeInOutExpo,
                                  ),
                                );
                                animationController.forward();

                                lastResult = result;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnimatedContainer(
                                      constraints: BoxConstraints(
                                        minWidth: kLittleSpace,
                                        maxWidth: MediaQuery.of(context).size.width * .7,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kLittleSpace),
                                      margin: const EdgeInsets.all(kLittleSpace / 4),
                                      duration: const Duration(seconds: 2),
                                      height: MediaQuery.of(context).size.height * .008,
                                      width: _calculateWidth(
                                        context: context,
                                        isIncome: i == 0,
                                        totalIn: totalInsByMonth[index],
                                        totalOut: totalOutsByMonth[index],
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: 20.toRadio(),
                                        color: i == 0 ? kLightGreen : kRed,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 3,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .15,
                                      child: AnimatedBuilder(
                                        builder: (context, _) {
                                          return FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${intTween.value}',
                                              style: TextStyle(
                                                color: i == 0 ? kDarkGreen : kRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                        animation: intTween,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
    );
  }

  List<int> totalByMonth(List<Pay> pays, int year) {
    List<int> totalByMonth = [];

    for (var i = 1; i <= 12; i++) {
      var total = pays
          .where((element) => element.date.month == i && element.date.year == year)
          .fold<int>(0, (previousValue, element) => previousValue + element.value);
      totalByMonth.add(total);
    }
    return totalByMonth;
  }

  double _calculateWidth(
      {required int totalIn,
      required int totalOut,
      required BuildContext context,
      required bool isIncome}) {
    final total = totalIn + totalOut;

    final current = isIncome ? totalIn : totalOut;

    return (MediaQuery.of(context).size.width - kSpace * 6 - 4) *
        (current * 100 / total) *
        .01;
  }

  bool _canShow(int totalIn, int totalOut, int index) {
    return (totalIn != 0 || totalOut != 0);
  }
}
