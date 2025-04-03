import 'package:flutter/material.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/utils/type_handler.dart';
import 'package:intl/intl.dart';

class MyPayTile extends StatelessWidget {
  MyPayTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final Pay item;
  final VoidCallback onTap;
  final formatter = DateFormat('dd - MM');

  @override
  Widget build(BuildContext context) {
    final dateFormatted = formatter.format(item.date);

    return ListTile(
      tileColor: Colors.transparent,
      leading: Icon(getIcon(item.type)),
      title: Text(
        item.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: kBlueGrey,
        ),
      ),
      subtitle: Text(
        '   $dateFormatted',
        style: const TextStyle(
          fontWeight: FontWeight.w100,
          color: Colors.white38,
        ),
      ),
      trailing: Text(
        ' ${item.value}',
        style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: kBlueGrey),
      ),
      onTap: onTap,
    );
  }
}
