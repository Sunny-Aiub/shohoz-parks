import 'package:flutter/material.dart';

class ColorManager {
  static var primaryWhite = Colors.white;
  static var primaryBlack = Colors.black;
  static Color primaryGreen = HexColor.fromHex("#079D49");

  static var inputFieldTitleColor333333 = HexColor.fromHex("#333333");
  static var inputFieldTitleColorF4F4F4 = HexColor.fromHex("#F4F4F4");
  static var inputFieldTextColor = HexColor.fromHex("#2F2F2F");
  static var inputFieldBackgroundColor = HexColor.fromHex("#D5E6FB");

  static var buttonBackgroundColor = HexColor.fromHex("#2F80ED");
  static var gray707070 = HexColor.fromHex("#707070");
  static var grayE4E4E4 = HexColor.fromHex("#E4E4E4");
  static var backgroundColor = HexColor.fromHex('#F0F0F0');
  static var textColor999999 = HexColor.fromHex('#999999');

  static var yellowF2994A= HexColor.fromHex('#F2994A');
  static var black595C7D= HexColor.fromHex('#595C7D');

}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
