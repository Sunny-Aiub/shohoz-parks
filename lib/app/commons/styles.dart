import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle(
    double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.barlow(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight);
}


TextStyle _getCustomTextStyle(
    double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.barlow(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight);
}

/// Semi Bold H1 style
TextStyle getSemiBoldStyle(
    {required double fontSize, required Color color}) {
  return _getCustomTextStyle(
      fontSize,  FontWeightManager.semiBold, color);
}

/// Semi Bold  style
TextStyle getBoldStyle(
    {required double fontSize, required Color color}) {
  return _getCustomTextStyle(
      fontSize,  FontWeightManager.bold, color);
}


// regular style
TextStyle getRegularStyle(
    {required double fontSize, required Color color}) {
  return _getCustomTextStyle(
      fontSize,  FontWeightManager.regular, color);
}
// Semi Bold style
TextStyle getMediumStyle(
    {required double fontSize, required Color color}) {
  return _getCustomTextStyle(
      fontSize,  FontWeightManager.medium, color);
}

class FontWeightManager {
  static const FontWeight w400 = FontWeight.w400;
  static const FontWeight w500 = FontWeight.w500;
  static const FontWeight w600 = FontWeight.w600;
  static const FontWeight w700 = FontWeight.w700;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w400;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.bold;

}

class FontSize {
  static const double px12 = 12.0;
  static const double px14 = 14.0;
  static const double px16 = 16.0;
  static const double px20 = 20.0;
  static const double px24 = 24.0;
  static const double px30 = 30.0;

}