import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: kBlueGrey,
      endIndent: kSpace,
      indent: kLittleSpace,
      height: kLittleSpace,
    );
  }
}
