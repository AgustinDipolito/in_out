import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:in_out/servicies/config_service.dart';

class TypeFilter extends StatelessWidget {
  const TypeFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var configService = Provider.of<ConfigService>(context);
    var isSelect = configService.isIncome;

    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...List.generate(
            2,
            (index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLittleSpace, vertical: 1),
                child: GestureDetector(
                  onTap: () => configService.switchType(),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: kBlueGrey,
                      fontWeight: isSelect && index == 1 || !isSelect && index == 0
                          ? FontWeight.w900
                          : FontWeight.w100,
                      fontSize:
                          isSelect && index == 1 || !isSelect && index == 0 ? 16 : 14,
                    ),
                    child: Text(index == 0 ? 'Exp.' : 'Inc.'),
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
