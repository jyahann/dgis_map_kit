import 'package:flutter/material.dart';

enum MapIconTextPlacement {
  NO_LABEL,
  BOTTOM_CENTER,
  BOTTOM_RIGHT,
  BOTTOM_LEFT,
  CIRCLE_BOTTOM_RIGHT,
  RIGHT_BOTTOM,
  RIGHT_CENTER,
  RIGHT_TOP,
  CIRCLE_TOP_RIGHT,
  TOP_CENTER,
  TOP_RIGHT,
  TOP_LEFT,
  CIRCLE_TOP_LEFT,
  LEFT_TOP,
  LEFT_CENTER,
  LEFT_BOTTOM,
  CIRCLE_BOTTOM_LEFT,
  CENTER_CENTER
}

class MapIconTextStyle {
  final double fontSize;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final MapIconTextPlacement textPlacement;
  final double textOffset;

  const MapIconTextStyle({
    this.fontSize = 8.0,
    this.color = Colors.black,
    this.strokeWidth = 0.4,
    this.strokeColor = Colors.black,
    this.textPlacement = MapIconTextPlacement.BOTTOM_CENTER,
    this.textOffset = 0.0,
  });

  MapIconTextStyle.fromJson(Map<String, dynamic> json)
      : fontSize = json["fontSize"],
        color = Color(json["color"]),
        strokeWidth = json["strokeWidth"],
        strokeColor = Color(json["strokeColor"]),
        textPlacement = MapIconTextPlacement.values
            .firstWhere((e) => e.name == json["textPlacement"]),
        textOffset = json["textOffset"];

  Map<String, dynamic> toJson() => {
        "fontSize": fontSize,
        "color": color.value,
        "strokeWidth": strokeWidth,
        "strokeColor": strokeColor.value,
        "textPlacement": textPlacement.name,
        "textOffset": textOffset,
      };
}
