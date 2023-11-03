import 'package:dgis_map_platform_interface/src/models/map_icon_options.dart';
import 'package:dgis_map_platform_interface/src/models/position.dart';

// A marker model that contains settings for rendering on the map.
class Marker {
  // ID should be unique or null.
  // If the ID is null, the search, deletion,
  // and update of the marker will not be carried out.
  // If marker with given id already exists, it will be overwritten.
  final String? id;

  // Marker's position on map.
  final Position position;

  // Marker's icon based on its asset.
  final String icon;

  // Marker's icon options.
  final MapIconOptions iconOptions;

  // Elevation in meters above
  // the ground surface, not above sea level.
  final double elevation;

  // The data that will be saved and retrieved in map events.
  final Map<String, dynamic>? data;

  const Marker({
    this.id,
    required this.position,
    required this.icon,
    this.iconOptions = const MapIconOptions(),
    this.elevation = 0.0,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position.toJson(),
        "icon": icon,
        "iconOptions": iconOptions.toJson(),
        'elevation': elevation,
        "data": data,
      };

  Marker.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        position = Position.fromJson(
          (json["position"] as Map<Object?, Object?>).cast<String, dynamic>(),
        ),
        icon = json["icon"],
        iconOptions = MapIconOptions.fromJson(
          (json["iconOptions"] as Map<Object?, Object?>)
              .cast<String, dynamic>(),
        ),
        elevation = json["elevation"],
        data = json["data"] == null
            ? null
            : (json["data"] as Map<Object?, Object?>).cast<String, dynamic>();

  Marker copyWith({
    String? Function()? id,
    Position? position,
    String? icon,
    MapIconOptions? iconOptions,
    double? elevation,
    Map<String, dynamic>? Function()? data,
  }) {
    return Marker(
      id: id != null ? id() : this.id,
      position: position ?? this.position,
      icon: icon ?? this.icon,
      iconOptions: iconOptions ?? this.iconOptions,
      elevation: elevation ?? this.elevation,
      data: data != null ? data() : this.data,
    );
  }
}
