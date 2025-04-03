part of 'widgets.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final incomeService = Provider.of<PaysService>(context);
    final periodoService = Provider.of<ConfigService>(context);

    var historyFiltered = incomeService.history
        .where((element) => element.date.isAfter(periodoService.dateLimit))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width - kSpace - 4,
      child: Container(
        padding: const EdgeInsets.all(5),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: 20.toRadio(),
          border: Border.all(color: Colors.black12),
          color: kBlueGrey,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: historyFiltered.isEmpty
            ? FittedBox(
                fit: BoxFit.fitWidth,
                child: Icon(
                  Icons.history,
                  color: kblack.withOpacity(.5),
                ),
              )
            : ListView.builder(
                itemExtent: MediaQuery.of(context).size.height * .085,
                itemCount: historyFiltered.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = historyFiltered[index];
                  var formatter = DateFormat('dd - MM');
                  var dateFormatted = formatter.format(item.date);

                  return Dismissible(
                    key: Key('item.name-${item.date}-${item.value}'),
                    onDismissed: (direction) => incomeService.deleteOne(item),
                    background: ColoredBox(
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            2,
                            (i) => const Text(
                              '  Remove?  ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: ListTile(
                      tileColor: Colors.transparent,
                      leading: item.isIncome
                          ? const Icon(Icons.add)
                          : item.type != PayType.none
                              ? Icon(getIcon(item.type))
                              : null,
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kblack,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('   $dateFormatted'),
                          const Spacer(),
                          Text(
                            '${item.isIncome ? '+' : '-'} ${item.value}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: item.isIncome ? kLightGreen : kRed,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.monetization_on,
                        color: item.isIncome ? kLightGreen : kRed,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
