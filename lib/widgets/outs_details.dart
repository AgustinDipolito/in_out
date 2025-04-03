import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/utils/type_handler.dart';
import 'package:in_out/utils/get_percentajes_by_icons.dart';
import 'package:in_out/utils/get_values_by_icons.dart';
import 'package:in_out/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/pay.dart';
import '../servicies/config_service.dart';
import '../servicies/pays_service.dart';

class OutsDetails extends StatefulWidget {
  const OutsDetails({Key? key}) : super(key: key);

  @override
  State<OutsDetails> createState() => _OutsDetailsState();
}

class _OutsDetailsState extends State<OutsDetails> with SingleTickerProviderStateMixin {
  final List<IconData> icons = List.generate(
    PayType.values.length,
    (index) => getIcon(PayType.values[index]),
  );

  late final AnimationController animationController;
  int lastResult = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final periods = Provider.of<ConfigService>(context);
    final service = Provider.of<PaysService>(context);
    final outs = service.getOutsHistory(periods.dateLimit);

    service.addListener(() => animationController.repeat());
    periods.addListener(() => animationController.repeat());

    var values = getValuesByIcons(outs, icons);

    var iconValueMap = Map.fromIterables(icons, values)
      ..removeWhere((key, value) => value < 1);

    iconValueMap = Map.fromEntries(
        iconValueMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));

    return Container(
      width: MediaQuery.of(context).size.width - kSpace - 4,
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
      child: iconValueMap.isEmpty
          ? const Center(
              child: Text(
                'Load your first Outcome!',
                style: TextStyle(
                  color: kblack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Column(
              children: List.generate(
                iconValueMap.length,
                (index) {
                  var icon = iconValueMap.keys.toList()[index];

                  var result = iconValueMap[icon]!.toInt();

                  Animation<int> intTween = IntTween(begin: lastResult, end: result)
                      .animate(CurvedAnimation(
                          parent: animationController, curve: Curves.easeInOutExpo));

                  animationController.forward();

                  lastResult = result;

                  return GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: ((context) => CategoryDetailDialog(
                            payType: getType(icon),
                          )),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: kLittleSpace),
                        Icon(
                          icon,
                          color: kblack,
                        ),
                        AnimatedContainer(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * .1,
                            maxWidth: MediaQuery.of(context).size.width - kSpace * 6 - 4,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: kLittleSpace),
                          margin: const EdgeInsets.all(kLittleSpace / 2),
                          duration: const Duration(seconds: 2),
                          height: MediaQuery.of(context).size.height * .025,
                          width: _calculateWidth(iconValueMap, index),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: 20.toRadio(),
                            color: kblack,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: AnimatedBuilder(
                            builder: (context, _) {
                              return FittedBox(
                                child: Text(
                                  '${intTween.value}',
                                  style: const TextStyle(
                                    color: kBlueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              );
                            },
                            animation: intTween,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  double _calculateWidth(Map<IconData, double> iconValueMap, int index) {
    return MediaQuery.of(context).size.width *
        (getPercetajesByIcons(iconValueMap.values.toList())[index] / 100);
  }
}
