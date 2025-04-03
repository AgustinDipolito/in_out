import 'dart:convert';

class Pay {
  // final DateTime date= DateTime.now();
  final DateTime date;
  final int value;
  final bool isIncome;
  final String name;
  final PayType type;

  Pay({
    required this.date,
    required this.name,
    required this.value,
    required this.isIncome,
    this.type = PayType.none,
  });

  Pay copyWith({
    DateTime? date,
    String? name,
    int? value,
    bool? isIncome,
    PayType? type,
  }) =>
      Pay(
        date: date ?? this.date,
        name: name ?? this.name,
        value: value ?? this.value,
        isIncome: isIncome ?? this.isIncome,
        type: type ?? this.type,
      );

  @override
  String toString() =>
      'El dia ${date.toString().substring(0, 10)}, ${isIncome ? 'gane' : 'gaste'} \$$value en $name. Tipo: ${getPayTypeString(type)}.';

  factory Pay.fromRawJson(String str) => Pay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory Pay.fromJson(Map<String, dynamic> json) => Pay(
        date: DateTime.parse(json["date"]),
        name: json["name"],
        value: int.parse(json["value"]),
        isIncome: json["isIncome"] == 'true',
        type: getStatusFromString(json["type"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "date": date.toIso8601String(),
        "name": name,
        "value": value.toString(),
        "isIncome": isIncome.toString(),
        "type": type.toString(),
      };
}

PayType getStatusFromString(String statusAsString) {
  for (PayType element in PayType.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return PayType.none;
}

enum PayType {
  none,
  house,
  health,
  party,
  food,
  car,
  pet,
  shop,
}

String getPayTypeString(PayType type) {
  switch (type) {
    case PayType.none:
      return 'Sin tipo';
    case PayType.house:
      return 'Casa';
    case PayType.health:
      return 'Amor';
    case PayType.party:
      return 'Lujos';
    case PayType.food:
      return 'Comida y Restorante';
    case PayType.car:
      return 'Transporte';
    case PayType.pet:
      return 'Mascota';
    case PayType.shop:
      return 'Almacenes y Tiendas';
  }
}
