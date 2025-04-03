part of 'widgets.dart';

class CategoryDetailDialog extends StatelessWidget {
  const CategoryDetailDialog({Key? key, required this.payType}) : super(key: key);

  final PayType payType;
  @override
  Widget build(BuildContext context) {
    final pays = Provider.of<PaysService>(context);
    final config = Provider.of<ConfigService>(context);

    List<Pay> outs = pays.getOutsHistory(config.dateLimit);
    outs = outs.where((element) => element.type == payType).toList();

    final total =
        outs.fold<int>(0, (previousValue, element) => previousValue + element.value);

    final highestValue = outs.map((e) => e.value).reduce(max);

    final highest = outs.firstWhere((element) => element.value == highestValue);
    final formatter = DateFormat('dd - MM');

    final dateFrom = formatter.format(config.dateLimit);

    return AlertDialog(
      backgroundColor: kblack,
      shape: RoundedRectangleBorder(
          borderRadius: 20.toRadio(), side: const BorderSide(color: kBlueGrey)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            getIcon(payType),
            size: 32,
            color: Colors.white38,
          ),
          const Text(
            'Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white38),
          ),
          Icon(
            getIcon(payType),
            size: 32,
            color: Colors.white38,
          ),
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'From $dateFrom',
                style:
                    const TextStyle(fontWeight: FontWeight.w100, color: Colors.white38),
              ),
            ),
            Divider(color: kBlueGrey.shade800),
            Flexible(
              child: ListTile(
                leading: const Icon(
                  Icons.monetization_on,
                  color: kBlueGrey,
                ),
                title: Text(
                  'Total expended is \$ $total',
                  style: const TextStyle(fontSize: 14, color: kBlueGrey),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(
                  Icons.whatshot,
                  color: kRed,
                ),
                title: Text(
                  'Highest pay was ${highest.name} ',
                  style: const TextStyle(fontSize: 14, color: kBlueGrey),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'on ${formatter.format(highest.date)}',
                  style: const TextStyle(fontSize: 12, color: kBlueGrey),
                ),
              ),
            ),
            Divider(color: kBlueGrey.shade800),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: outs.length,
                itemBuilder: (context, index) {
                  final item = outs[index];

                  return MyPayTile(
                    item: item,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
