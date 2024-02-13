import 'package:flutter/material.dart';

class GradientPolylineOptions {
  final double borderWidth;
  final double secondBorderWidth;
  final double gradientLength;
  final Color borderColor;
  final Color secondBorderColor;
  final Set<Color> colors;
  final List<int> colorStops;

  GradientPolylineOptions({
    required this.borderWidth,
    required this.secondBorderWidth,
    required this.gradientLength,
    required this.borderColor,
    required this.secondBorderColor,
    required this.colors,
    required this.colorStops,
  });

  Map<String, dynamic> toJson() => {
        "borderWidth": borderWidth,
        "secondBorderWidth": secondBorderWidth,
        "gradientLength": gradientLength,
        "borderColor": borderColor.value,
        "secondBorderColor": secondBorderColor.value,
        "colors": colors.map((e) => e.value).toSet(),
        "colorStops": colorStops,
      };

  GradientPolylineOptions.fromJson(Map<String, dynamic> json)
      : borderWidth = json["borderWidth"],
        secondBorderWidth = json["secondBorderWidth"],
        gradientLength = json["gradientLength"],
        borderColor = Color(json["borderColor"]),
        secondBorderColor = Color(json["secondBorderColor"]),
        colors = (json["colors"] as Set<int>).map((e) => Color(e)).toSet(),
        colorStops = json["colorStops"];

}
