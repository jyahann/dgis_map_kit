import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

/// The flight type is selected based on the
/// distance between the initial and final positions.
enum CameraAnimationType {
  defaultAnimation,

  /// Linear change of camera position parameters.
  linear,

  /// The zoom is adjusted in such a way as to try
  /// to display the initial and final positions at some
  /// point during the flight. Positions may not be
  /// displayed if the current constraints do not
  /// allow such a small zoom level.
  showBothPositions,
}

class CameraPosition {
  /// The geographical point located at the camera position.
  final Position position;

  /// Zoom = 0 is a scale at which the entire world fits
  /// into a square of 256x256 pixels.
  /// Zoom = 1 is a scale at which the entire world
  /// fits into a square of 512x512 pixels.
  /// The scale is proportional to 2^Zoom.
  final double zoom;

  /// The tilt angle in degrees, where 0 is nadir
  /// (looking vertically down), and 90 is the horizon in front.
  /// Valid values are considered to be in the range from 0 to 60 degrees.
  final double tilt;

  /// The angle between the direction to one object and another object,
  /// or between the direction to an object and north.
  /// The angle is measured clockwise. The range of values is from 0° to 360°.
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

  CameraPosition copyWith({
    Position? position,
    double? zoom,
    double? tilt,
    double? bearing,
  }) {
    return CameraPosition(
      position: position ?? this.position,
      zoom: zoom ?? this.zoom,
      tilt: tilt ?? this.tilt,
      bearing: bearing ?? this.bearing,
    );
  }
}
