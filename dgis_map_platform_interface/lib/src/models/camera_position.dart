import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

enum CameraAnimationType { DEFAULT, LINEAR, SHOW_BOTH_POSITIONS }

class CameraPosition {
  final Position position;
  final double zoom;
  final double tilt;
  final double bearing;

  CameraPosition({
    required this.position,
    required this.zoom,
    this.tilt = 0.0,
    this.bearing = 0.0,
  });

  Map<String, dynamic> toJson() => {
        "position": position.toJson(),
        "zoom": zoom,
        "tilt": tilt,
        "bearing": bearing,
      };

  CameraPosition.fromJson(Map<String, dynamic> json)
      : position = Position.fromJson(
          (json["position"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        zoom = json["zoom"],
        tilt = json["tilt"],
        bearing = json["bearing"];
}
