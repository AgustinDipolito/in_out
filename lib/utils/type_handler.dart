import 'package:flutter/material.dart';
import 'package:in_out/models/pay.dart';

IconData getIcon(PayType type) {
  var map = {
    PayType.car: Icons.car_rental,
    PayType.pet: Icons.pets,
    PayType.health: Icons.favorite,
    PayType.none: Icons.exit_to_app_rounded,
    PayType.shop: Icons.shopping_cart,
    PayType.house: Icons.home,
    PayType.party: Icons.star_half_rounded,
    PayType.food: Icons.fastfood,
  };

  return map[type]!;
}

PayType getType(IconData icon) {
  var map = {
    Icons.car_rental: PayType.car,
    Icons.pets: PayType.pet,
    Icons.favorite: PayType.health,
    Icons.exit_to_app_rounded: PayType.none,
    Icons.shopping_cart: PayType.shop,
    Icons.home: PayType.house,
    Icons.star_half_rounded: PayType.party,
    Icons.fastfood: PayType.food,
  };

  return map[icon]!;
}
