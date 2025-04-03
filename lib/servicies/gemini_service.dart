import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:in_out/models/gemini_financial_analisis.dart';
import 'package:in_out/servicies/keys.dart';

class GeminiService {
  final GenerativeModel model;
  bool requestInProgress = false;

  GeminiService(String apiKey)
      : model = GenerativeModel(
          model: 'gemini-2.0-flash-thinking-exp-01-21',
          apiKey: Keys.geminiAPiKey,
          generationConfig: GenerationConfig(
            temperature:
                0.5, // Reduce la creatividad y hace las respuestas más deterministas
            topK: 20, // Reduce la cantidad de palabras candidatas, enfocando la respuesta
            topP: 0.8, // Permite más flexibilidad en las elecciones sin perder coherencia
            maxOutputTokens: 4048,
            responseMimeType: 'text/plain',
          ),
          systemInstruction: Content.system(
            """Responde en español.
Eres un experto en análisis de datos y optimización de gastos personales. Recibirás una lista de gastos diarios (con fecha, monto, categoría y título) y deberás analizarla para identificar patrones y generar recomendaciones prácticas, precisas y objetivas. Tu tarea es procesar estos datos y devolver una lista de objetos de tipo "recomendacion".

Evita recomendaciones irreales o poco factibles, como mudarse o vender bienes esenciales. Las sugerencias deben estar alineadas con ajustes realistas en los hábitos de gasto, sin afectar necesidades básicas, y se deben proponer mejoras graduales y sostenibles sin cambios drásticos en el estilo de vida.

Además, enfócate en:
- Detectar anomalías en días específicos o en gastos que se desvían significativamente del promedio.
- Señalar gastos que podrían haberse evitado y detallar fechas o eventos concretos.
- Realizar estimaciones de gastos futuros basadas en patrones históricos.
- Comparar gastos actuales con promedios y resaltar desviaciones relevantes.

La salida debe estar en formato JSON, devolviendo únicamente la lista de objetos "recomendacion" sin ningún texto adicional, para que pueda ser fácilmente consumida por una aplicación Flutter.

Cada objeto "recomendacion" debe incluir las siguientes propiedades:
- **titulo (string):** Un título breve que resuma la recomendación.
- **descripcion (string):** Una explicación corta y precisa del análisis, indicando datos específicos, fechas o comparaciones relevantes.
- **categoria (string):** Asigna la categoría del gasto. Las únicas opciones disponibles son:
  - none (sin tipo)
  - house (casa)
  - health (amor)
  - party (lujos)
  - food (comida y restorantes)
  - car (transporte)
  - pet (mascotas)
  - shop (almacenes y tiendas)
- **valorRelevante (string):** Un valor numérico derivado del análisis (por ejemplo, porcentaje de gasto, cantidad de ahorro potencial, etc.) y su unidad correspondiente. No utilices símbolos de monedas.
- **indicadorCritico (booleano):** Un indicador que señala si la recomendación es crítica o prioritaria.

Ejemplo de salida:

[
  {
    "titulo": "Gasto inusual el 15 de marzo",
    "descripcion": "El 15 de marzo se registró un gasto de 12000 en la categoría shop, lo que supera en 3x el promedio habitual en esa categoría.",
    "categoria": "shop",
    "valorRelevante": "300 %",
    "indicadorCritico": true
  },
  {
    "titulo": "Compras impulsivas en delivery",
    "descripcion": "Se detectaron 6 pedidos de delivery en la última semana, representando un 18 % del gasto mensual en food.",
    "categoria": "food",
    "valorRelevante": "18 %",
    "indicadorCritico": false
  },
  {
    "titulo": "Estimación de gasto para abril",
    "descripcion": "Basado en los datos de los últimos 3 meses, se estima un gasto total de 75000 para abril, con un aumento proyectado del 7 % en car debido al incremento de viajes laborales.",
    "categoria": "car",
    "valorRelevante": "7 %",
    "indicadorCritico": false
  }
]

""",
          ),
        );

  Future<FinancialAnalysis?> sendMessage(String message) async {
    requestInProgress = true;
    final chat = model.startChat(history: []);
    final content = Content.text(message);
    final response = await chat.sendMessage(content);
    requestInProgress = false;
    if (response.text == null) return null;

    final decodedResponse =
        jsonDecode(response.text!.substring(7, response.text!.length - 4));
    if (decodedResponse is! List) return null;
    final List<Recomendacion> recomendaciones = decodedResponse
        .map<Recomendacion>((json) => Recomendacion.fromJson(json))
        .toList();

    final recomendation = FinancialAnalysis(recomendaciones: recomendaciones);
    return recomendation;
  }
}
