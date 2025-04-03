import 'package:flutter/material.dart';
import 'package:in_out/models/gemini_financial_analisis.dart';
import 'package:in_out/models/pay.dart';
import 'package:in_out/servicies/gemini_service.dart';
import 'package:in_out/servicies/pays_service.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/utils/type_handler.dart';
import 'package:provider/provider.dart';

class Recomendations extends StatefulWidget {
  const Recomendations({Key? key}) : super(key: key);

  @override
  State<Recomendations> createState() => _RecomendationsState();
}

class _RecomendationsState extends State<Recomendations> {
  Future<FinancialAnalysis?>? sendMessage;

  @override
  Widget build(BuildContext context) {
    final pays = Provider.of<PaysService>(context);
    final paysListed = pays.history.map((e) => e.toString()).join('\n');
    sendMessage ??= GeminiService('').sendMessage(paysListed);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .40,
      width: MediaQuery.of(context).size.width - kSpace - 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpace, vertical: kSpace),
        decoration: BoxDecoration(
          borderRadius: 20.toRadio(),
          border: Border.all(color: Colors.black12),
          color: kBlueGrey,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: FutureBuilder<FinancialAnalysis?>(
          future: sendMessage,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var recomendation = snapshot.data;
            if (recomendation == null) {
              return Column(
                children: [
                  const Text('No hay recomendaciones esta vez'),
                  IconButton(
                      onPressed: () async {
                        final pays = Provider.of<PaysService>(context, listen: false);
                        final paysListed =
                            pays.history.map((e) => e.toString()).join('\n');
                        recomendation = await GeminiService('').sendMessage(paysListed);
                      },
                      icon: const Icon(Icons.refresh)),
                ],
              );
            }

            // final analisis = recomendation.analisis;

            return Column(
              children: [
                const Text(
                  'Revisiones',
                  style: TextStyle(
                    color: kblack,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Flexible(
                    child: RecomendacionesWidget(
                        recomendaciones: recomendation.recomendaciones))
              ],
            );
          }),
        ),
      ),
    );
  }
}

class RecomendacionesWidget extends StatelessWidget {
  final List<Recomendacion> recomendaciones;

  const RecomendacionesWidget({Key? key, required this.recomendaciones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recomendaciones.length,
      itemBuilder: (context, index) {
        final rec = recomendaciones[index];
        return Card.outlined(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            title: Text(rec.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.valorRelevante,
                  style: TextStyle(
                      fontSize: 16, color: rec.indicadorCritico ? kRed : kDarkGreen),
                ),
                Text(rec.descripcion),
              ],
            ),
            trailing: Icon(getIcon(PayType.values.firstWhere(
              (v) => v.name == rec.categoria,
              orElse: () => PayType.none,
            ))),
          ),
        );
      },
    );
  }
}

class StyledTextWidget extends StatelessWidget {
  final String text;

  const StyledTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: _buildHighlightedSpans(text),
        style: const TextStyle(
          color: Colors.black, // Estilo base para el texto
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp pattern = RegExp(r'\b([A-Z][a-z]*|\d+)\b'); // Detecta nombres y valores
    final Iterable<RegExpMatch> matches = pattern.allMatches(text);

    int lastMatchEnd = 0;

    for (final match in matches) {
      // si es el inicio del texto, no tener en cuenta
      if (match.start == 0) {
        continue;
      }

      // Agregar texto regular antes del match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ));
      }

      // Resaltar el match en negrita
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Agregar texto después del último match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
      ));
    }

    return spans;
  }
}
