import 'package:dgis_map_platform_interface/src/models/map_icon.dart';
import 'package:dgis_map_platform_interface/src/models/position.dart';

class Marker {
  final int? id;
  final Position position;
  final MapIcon icon;
  final Map<String, dynamic>? data;

  const Marker({
    this.id,
    required this.position,
    this.icon = const MapIcon(),
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "position": position.toJson(),
      "icon": icon.toJson(),
      "data": data,
    };
  }

  Marker.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        position = Position.fromJson(json["position"]),
        icon = MapIcon.fromJson(json["icon"]),
        data = json["data"];
}
