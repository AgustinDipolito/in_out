import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.onTap, required this.tittle}) : super(key: key);
  final Function() onTap;
  final String tittle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - kSpace - 4,
      child: Material(
        color: kblack,
        elevation: 10,
        borderRadius: 20.toRadio(),
        child: InkWell(
          onTap: onTap,
          borderRadius: 20.toRadio(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tittle,
                  style: const TextStyle(
                    color: kBlueGrey,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(width: kLittleSpace, height: kBigSpace * 2),
              const Icon(
                Icons.login,
                color: kBlueGrey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
