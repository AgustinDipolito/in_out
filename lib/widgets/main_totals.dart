part of 'widgets.dart';

class MainTotals extends StatelessWidget {
  const MainTotals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - kSpace - 4,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Banner(backgroundColor: kRed)),
          SizedBox(width: kLittleSpace),
          Expanded(child: Banner(backgroundColor: kLightGreen)),
        ],
      ),
    );
  }
}

class Banner extends StatefulWidget {
  final Color backgroundColor;

  const Banner({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  State<Banner> createState() => _BannerState();
}

class _BannerState extends State<Banner> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  int lastResult = 0;

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

    var result = widget.backgroundColor == kRed
        ? service.getOuts(periods.dateLimit)
        : service.getIns(periods.dateLimit);

    service.addListener(() => animationController.repeat());
    periods.addListener(() => animationController.repeat());

    Animation<int> intTween = IntTween(begin: lastResult, end: result).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOutExpo));

    animationController.forward();

    lastResult = result;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: Offset(2, 2),
          )
        ],
        borderRadius: 20.toRadio(),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            widget.backgroundColor == kRed ? Icons.outbound : Icons.input,
            color: Colors.black,
          ),
          AnimatedBuilder(
            animation: intTween,
            builder: (context, child) {
              return Text(
                '\$ ${intTween.value}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              );
            },
          )
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
