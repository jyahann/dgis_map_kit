import 'package:dgis_map_platform_interface/src/models/map_icon_options.dart';
import 'package:dgis_map_platform_interface/src/models/position.dart';

class Marker {
  final String? id;
  final Position position;
  final String icon;
  final double elevation;
  final MapIconOptions iconOptions;
  final Map<String, dynamic>? data;

  const Marker({
    this.id,
    required this.position,
    required this.icon,
    this.elevation = 0,
    this.iconOptions = const MapIconOptions(),
    this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position.toJson(),
        "icon": icon,
        "elevation": elevation,
        "iconOptions": iconOptions.toJson(),
        "data": data,
      };

  Marker.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        position = Position.fromJson(
          (json["position"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        icon = json["icon"],
        elevation = json["elevation"],
        iconOptions = MapIconOptions.fromJson(
          (json["iconOptions"] as Map<Object?, Object?>)
              .cast<String, dynamic>(),
        ),
        data = json["data"] == null
            ? null
            : (json["data"] as Map<Object?, Object?>).cast<String, dynamic>();
}
