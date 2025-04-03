import 'package:flutter/material.dart';
import 'package:in_out/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:in_out/servicies/pays_service.dart';
import 'package:in_out/servicies/config_service.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/utils/type_handler.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/utils/get_values_by_icons.dart';
import 'package:in_out/utils/get_percentajes_by_icons.dart';

class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  final colors = [
    Colors.blueGrey.shade500,
    Colors.blueGrey.shade300,
    Colors.blueGrey.shade600,
    Colors.blueGrey.shade50,
    Colors.blueGrey.shade700,
    Colors.blueGrey.shade200,
    Colors.blueGrey.shade800,
    Colors.blueGrey.shade400,
    Colors.blueGrey.shade900,
    Colors.blueGrey.shade100,
  ];

  final List<IconData> icons =
      List.generate(PayType.values.length, (index) => getIcon(PayType.values[index]));

  @override
  Widget build(BuildContext context) {
    final periods = Provider.of<ConfigService>(context);
    final outs = Provider.of<PaysService>(context).getOutsHistory(periods.dateLimit);

    return AspectRatio(
      aspectRatio: 1.3,
      child: SizedBox(
        child: AspectRatio(
          aspectRatio: 1,
          child: outs.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  height: 125,
                  width: 125,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kBlueGrey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    decoration:
                        const BoxDecoration(shape: BoxShape.circle, color: kblack),
                    child: const Text(
                      '%',
                      style: TextStyle(
                        color: kBlueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 272,
                      height: 272,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: kBlueGrey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: true),
                        sectionsSpace: 2,
                        centerSpaceRadius: 10,
                        sections: showingSections(periods.dateLimit, outs, icons),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      DateTime dateLimit, List<Pay> outs, List<IconData> icons) {
    var values = getValuesByIcons(outs, icons);
    var percentajes = getPercetajesByIcons(values);

    return List.generate(icons.length, (i) {
      const fontSize = 16.0;
      const radius = 125.0;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: '${percentajes[i]}%',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        badgeWidget: _Badge(icon: icons[i]),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;

  const _Badge({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: ((context) => CategoryDetailDialog(
              payType: getType(icon),
            )),
      ),
      child: AnimatedContainer(
        duration: PieChart.defaultDuration,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: kBlueGrey,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: kRed,
              blurRadius: 6,
              offset: Offset(1, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(2),
        child: Center(child: Icon(icon)),
      ),
    );
  }
}
