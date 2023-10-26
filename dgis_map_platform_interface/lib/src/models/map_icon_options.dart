import 'dart:ffi';

import 'package:dgis_map_platform_interface/src/models/map_icon_text_style.dart';
import 'package:flutter/gestures.dart';

class MapIconOptions {
  final double size;
  final String? text;
  final MapIconTextStyle textStyle;
  final int zIndex;
  final Offset anchor;

  const MapIconOptions({
    this.size = 12.0,
    this.text,
    this.zIndex = 0,
    this.textStyle = const MapIconTextStyle(),
    this.anchor = const Offset(0.5, 0.5),
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'text': text,
      'textStyle': textStyle.toJson(),
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
        textStyle = MapIconTextStyle.fromJson(
          (json["textStyle"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        zIndex = json["zIndex"],
        anchor = Offset(
          json["anchor"]["x"] as double,
          json["anchor"]["y"] as double,
        );
}
