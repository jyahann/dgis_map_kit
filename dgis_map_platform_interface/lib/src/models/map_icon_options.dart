import 'package:dgis_map_platform_interface/src/models/map_anchor.dart';
import 'package:dgis_map_platform_interface/src/models/map_icon_text_style.dart';

class MapIconOptions {
  // Map icon size
  final double size;

  // Map icon label
  final String? text;

  // Label style.
  final MapIconTextStyle textStyle;

  // Icon zIndex.
  final int zIndex;

  // Icon anchor point.
  final MapAnchor anchor;

  // Icon opacity.
  final double iconOpacity;

  // Rotation angle of the icon on the map
  // relative to the north direction, clockwise.
  final double? iconMapDirection;

  // Animate the appearance.
  final bool animatedAppearance;

  const MapIconOptions({
    this.size = 12.0,
    this.text,
    this.zIndex = 0,
    this.textStyle = const MapIconTextStyle(),
    this.anchor = const MapAnchor(0.5, 0.5),
    this.iconOpacity = 1.0,
    this.iconMapDirection,
    this.animatedAppearance = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'text': text,
      'textStyle': textStyle.toJson(),
      'zIndex': zIndex,
      'anchor': anchor.toJson(),
      'iconOpacity': iconOpacity,
      'iconMapDirection': iconMapDirection,
      'animatedAppearance': animatedAppearance,
    };
  }

  MapIconOptions.fromJson(Map<String, dynamic> json)
      : size = json["size"],
        text = json["text"],
        textStyle = MapIconTextStyle.fromJson(
          (json["textStyle"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        zIndex = json["zIndex"],
        anchor = MapAnchor.fromJson(
          (json["anchor"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        iconOpacity = json["iconOpacity"],
        iconMapDirection = json["iconMapDirection"],
        animatedAppearance = json["animatedAppearance"];

  MapIconOptions copyWith({
    double? size,
    String? Function()? text,
    MapIconTextStyle? textStyle,
    int? zIndex,
    MapAnchor? anchor,
    double? iconOpacity,
    double? Function()? iconMapDirection,
    bool? animatedAppearance,
  }) {
    return MapIconOptions(
      size: size ?? this.size,
      text: text != null ? text() : this.text,
      textStyle: textStyle ?? this.textStyle,
      zIndex: zIndex ?? this.zIndex,
      anchor: anchor ?? this.anchor,
      iconOpacity: iconOpacity ?? this.iconOpacity,
      iconMapDirection:
          iconMapDirection != null ? iconMapDirection() : this.iconMapDirection,
      animatedAppearance: animatedAppearance ?? this.animatedAppearance,
    );
  }
}
