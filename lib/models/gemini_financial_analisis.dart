class FinancialAnalysis {
  final List<Recomendacion> recomendaciones;

  FinancialAnalysis({required this.recomendaciones});
}

class Recomendacion {
  // json
  //{
  // "titulo": "Alta variabilidad en gastos de transporte",
  // "descripcion": "Los gastos en transporte varían significativamente entre semanas, con picos altos los días lunes y viernes. Esto sugiere posibles oportunidades para optimizar desplazamientos.",
  // "categoria": "transporte",
  // "valorRelevante": 20.5,
  // "indicadorCritico": false
  // }

  final String titulo;
  final String descripcion;
  final String categoria;
  final String valorRelevante;
  final bool indicadorCritico;

  Recomendacion({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.valorRelevante,
    required this.indicadorCritico,
  });

  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      categoria: json['categoria'],
      valorRelevante: json['valorRelevante'],
      indicadorCritico: json['indicadorCritico'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'valorRelevante': valorRelevante,
      'indicadorCritico': indicadorCritico,
    };
  }

  @override
  String toString() {
    return 'Recomendacion{titulo: $titulo, descripcion: $descripcion, categoria: $categoria, valorRelevante: $valorRelevante, indicadorCritico: $indicadorCritico}';
  }
}
