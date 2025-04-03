import 'package:flutter/material.dart';
import 'package:in_out/servicies/pays_service.dart';
import 'package:in_out/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/pay.dart';
import '../utils/type_handler.dart';

class NewPayDialog extends StatefulWidget {
  final bool isIncome;
  const NewPayDialog({Key? key, required this.isIncome}) : super(key: key);

  @override
  State<NewPayDialog> createState() => _NewPayDialogState();
}

class _NewPayDialogState extends State<NewPayDialog> {
  final pricecontroller = TextEditingController();
  final nameController = TextEditingController();
  PayType type = PayType.none;
  DateTime fecha = DateTime.now();

  @override
  void dispose() {
    pricecontroller.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<PaysService>(context);

    return AlertDialog(
      backgroundColor: kBlueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: 20.toRadio(),
        side: BorderSide(color: widget.isIncome ? kLightGreen : kRed),
      ),
      title: Text(
        widget.isIncome ? 'New income' : 'New pay',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            cursorColor: widget.isIncome ? kDarkGreen : kRed,
            decoration: InputDecoration(
              hintText: 'Alias',
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kblack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.isIncome ? kDarkGreen : kRed),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: kblack),
              ),
            ),
          ),
          TextField(
            controller: pricecontroller,
            keyboardType: TextInputType.number,
            cursorColor: widget.isIncome ? kDarkGreen : kRed,
            decoration: InputDecoration(
              hintText: '¿How much?',
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kblack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.isIncome ? kDarkGreen : kRed),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: kblack),
              ),
            ),
          ),
          TextButton.icon(
              onPressed: () async {
                await _selectDate(context);
              },
              icon: Icon(
                Icons.calendar_month,
                color: widget.isIncome ? kDarkGreen : kRed,
              ),
              label: Text(
                '${fecha.day}/${fecha.month}/${fecha.year}',
                style: TextStyle(color: widget.isIncome ? kDarkGreen : kRed),
              )),
          const SizedBox(height: kSpace),
          if (!widget.isIncome)
            Flexible(
              child: Wrap(
                spacing: kSpace,
                runSpacing: kSpace,
                children: List.generate(
                  PayType.values.length - 1,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        type = PayType.values[index + 1];
                        setState(() {});
                      },
                      child: Icon(
                        getIcon(
                          PayType.values[index + 1],
                        ),
                        color: index + 1 == type.index
                            ? widget.isIncome
                                ? kLightGreen
                                : kRed
                            : Colors.black,
                        size: 36,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            "Add!",
            style: TextStyle(
              fontSize: kSpace,
              color: widget.isIncome ? kDarkGreen : kRed,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (pricecontroller.text.isNotEmpty || nameController.text.isNotEmpty) {
              var pay = Pay(
                date: fecha,
                isIncome: widget.isIncome,
                value: int.parse(pricecontroller.text),
                name: nameController.text,
                type: type,
              );

              service.newPay(pay);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.isIncome ? kDarkGreen : kRed,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != fecha) {
      setState(() {
        fecha = picked;
      });
    }
  }
}
