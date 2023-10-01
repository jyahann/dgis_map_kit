import 'package:flutter/gestures.dart';

class MapIcon {
  final String? icon;
  final double size;
  final String? text;
  final int? zIndex;
  final Offset anchor;

  const MapIcon({
    this.icon,
    this.size = 12.0,
    this.text,
    this.zIndex,
    this.anchor = const Offset(0.5, 0.5),
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'size': size,
      'text': text,
      'zIndex': zIndex,
      'anchor': anchor,
    };
  }

  MapIcon.fromJson(Map<String, dynamic> json)
      : icon = json["icon"],
        size = json["size"],
        text = json["text"],
        zIndex = json["zIndex"],
        anchor = json["anchor"];
}
