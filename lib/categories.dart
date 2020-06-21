import 'package:flutter/material.dart';

class Categories {
  static const all = "all";
  static const minimalist = "minimalist";
  static const landscape = "landscape";
  static const floral = 'floral';
  static const food = 'food';

  static List<String> catNamesList = <String>[
    Categories.all,
    Categories.food,
    Categories.minimalist,
    Categories.landscape,
    Categories.floral,
  ];
}
