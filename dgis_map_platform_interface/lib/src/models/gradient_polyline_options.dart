import 'package:flutter/material.dart';

class GradientPolylineOptions {
  final double borderWidth;
  final double secondBorderWidth;
  final double gradientLength;
  final Color borderColor;
  final Color secondBorderColor;
  final List<Color> colors;
  final List<int> colorIndices;

  GradientPolylineOptions({
    required this.borderWidth,
    required this.secondBorderWidth,
    required this.gradientLength,
    required this.borderColor,
    required this.secondBorderColor,
    required this.colors,
    required this.colorIndices,
  });

  Map<String, dynamic> toJson() => {
        "borderWidth": borderWidth,
        "secondBorderWidth": secondBorderWidth,
        "gradientLength": gradientLength,
        "borderColor": borderColor.value,
        "secondBorderColor": secondBorderColor.value,
        'colors': colors.map<int>((e) => e.value),
        "colorIndices": colorIndices,
      };

  GradientPolylineOptions.fromJson(Map<String, dynamic> json)
      : borderWidth = json["borderWidth"],
        secondBorderWidth = json["secondBorderWidth"],
        gradientLength = json["gradientLength"],
        borderColor = Color(json["borderColor"]),
        secondBorderColor = Color(json["secondBorderColor"]),
        colors = (json["colors"] as List<int>)
            .map<Color>(
              (e) => Color(e),
            )
            .toList(),
        colorIndices = json["colorIndices"];
}
