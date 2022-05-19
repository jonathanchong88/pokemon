import 'package:flutter/material.dart';

// Light theme
const Color lightPrimaryColor = Color(0xFF1E1E1E);
const Color lightAccentColor = Color(0xFF1E5185);

// Dark theme
const Color darkPrimaryColor = Color(0xFF121212);
const Color darkAccentColor = Color(0xFF18216C);
const Color darkBackgroundColor = Color(0xFF1F1F1F);
const Color darkCanvasColor = Color(0xFF242424);
const Color darkCardColor = Color(0xFF272727);
const Color darkDividerColor = Color(0xFF545454);

// Black theme
const Color blackPrimaryColor = Color(0xFF000000);
const Color blackAccentColor = Color(0xFFFFFFFF);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
