import 'package:flutter/material.dart';

const kRed = Color(0xFFA62B1F);
const kDarkGreen = Color(0xFF214001);
const kLightGreen = Color.fromARGB(255, 64, 124, 3);
const kblack = Colors.black;
const kRose = Color(0xFFD96941);
const kBlueGrey = Colors.blueGrey;

const double kLittleSpace = 8;
const double kSpace = 16;
const double kBigSpace = 24;

// final kBorderRadius = 20.toRadio();

//TODO sacar de este file
extension Radios on int {
  BorderRadius toRadio() => BorderRadius.circular(toDouble());
}
