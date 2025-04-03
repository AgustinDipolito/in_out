import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:in_out/servicies/config_service.dart';

class DateFilter extends StatelessWidget {
  const DateFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var periodoService = Provider.of<ConfigService>(context);

    return Container(
      // height: 22,
      margin: const EdgeInsets.only(right: kLittleSpace),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: 20.toRadio(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...List.generate(
            4,
            (index) {
              var isSelect = periodoService.getPeriodLimit(periodoService.dateLimit) ==
                  periodoService.periods[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLittleSpace, vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    periodoService.newPeriod(periodoService.periods[index]);
                  },
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: kBlueGrey,
                      fontWeight: isSelect ? FontWeight.w900 : FontWeight.w100,
                      fontSize: isSelect ? 16 : 14,
                    ),
                    child: Text(
                      periodoService.periods[index],
                      style: TextStyle(
                        fontSize: isSelect ? 16 : 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
