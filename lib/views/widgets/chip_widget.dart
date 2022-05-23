import 'package:flutter/material.dart';

///Common method to design a chip with different properties
///like label and background color
Widget chipDesign(String label, Color color) => Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        elevation: 4,
        shadowColor: Colors.grey[50],
        padding: const EdgeInsets.all(4),
      ),
    );
