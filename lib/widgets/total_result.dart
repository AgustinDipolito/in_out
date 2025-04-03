part of 'widgets.dart';

class TotalResult extends StatefulWidget {
  const TotalResult({Key? key}) : super(key: key);

  @override
  State<TotalResult> createState() => _TotalResultState();
}

class _TotalResultState extends State<TotalResult> with TickerProviderStateMixin {
  late final AnimationController animationController;
  // int result = 0;
  int tweenBegin = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<PaysService>(context);
    final periods = Provider.of<ConfigService>(context);

    service.addListener(() => animationController.repeat());
    periods.addListener(() => animationController.repeat());

    final int result =
        service.getIns(periods.dateLimit) - service.getOuts(periods.dateLimit);

    final bool isPositive = !result.isNegative;

    final Animation<int> intTween = IntTween(begin: tweenBegin, end: result).animate(
      CurvedAnimation(
        curve: Curves.easeInOutExpo,
        parent: animationController,
      ),
    );

    animationController.forward();
    int out = service.getOuts(periods.dateLimit);
    int totalIn = service.getIns(periods.dateLimit);

    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      width: MediaQuery.of(context).size.width - kSpace - 4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: 20.toRadio(),
        border: Border.all(color: Colors.black12),
        gradient: LinearGradient(
          colors: const [kRed, kLightGreen],
          stops: out > 1 || totalIn > 1
              ? [
                  (out / totalIn) - .05,
                  (out / totalIn) + .05,
                ]
              : [.48, .52],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            service.getIns(periods.dateLimit) > service.getOuts(periods.dateLimit)
                ? Icons.thumb_up
                : Icons.thumb_down,
            color: Colors.black,
          ),
          AnimatedBuilder(
            animation: intTween,
            builder: (_, child) {
              tweenBegin = intTween.value;
              return Text(
                '${isPositive ? '+ ' : ''}\$ ${intTween.value}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
