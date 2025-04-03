part of 'widgets.dart';

class Tittle extends StatelessWidget {
  const Tittle({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kSpace, bottom: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: kBlueGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
