import 'dart:ffi';

import 'package:flutter/gestures.dart';

class MapIconOptions {
  final double size;
  final String? text;
  final int zIndex;
  final Offset anchor;

  const MapIconOptions({
    this.size = 12.0,
    this.text,
    this.zIndex = 0,
    this.anchor = const Offset(0.5, 0.5),
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'text': text,
      'zIndex': zIndex,
      'anchor': {
        "x": anchor.dx,
        "y": anchor.dy,
      },
    };
  }

  MapIconOptions.fromJson(Map<String, dynamic> json)
      : size = json["size"],
        text = json["text"],
        zIndex = json["zIndex"],
        anchor = Offset(
          json["anchor"]["x"] as double,
          json["anchor"]["y"],
        );
}
