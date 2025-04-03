part of 'widgets.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final service = Provider.of<PaysService>(context);
    // final outs = service.getOutsHistory(DateTime(DateTime.now().year));
    // final ins = service.getInsHistory(DateTime(DateTime.now().year));

    // _controller.repeat();
    return Padding(
      padding: const EdgeInsets.only(bottom: kLittleSpace, right: kLittleSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('inButton'),
            heroTag: 'inButton',
            onPressed: () {
              _showDialog(
                context,
                true,
              );
            },
            elevation: 20,
            backgroundColor: kLightGreen,
            foregroundColor: kblack,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add_circle_outline,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: kSpace),
          FloatingActionButton(
            key: const Key('outButton'),
            heroTag: 'outButton',
            onPressed: () {
              _showDialog(context, false);
            },
            elevation: 20,
            foregroundColor: kblack,
            backgroundColor: kRed,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.outbound_outlined,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: kSpace),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, bool isIncome) {
    showDialog(
      context: context,
      builder: (context) {
        return NewPayDialog(isIncome: isIncome);
      },
    );
  }
}
