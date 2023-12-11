import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

/// Cluster model with its configuration.
class Cluster {
  /// Cluster's icon based on its asset.
  final String? icon;

  /// Cluster's icon options.
  final MapIconOptions iconOptions;

  /// Getting and setting the cluster appearance animation flag.
  final bool isAnimated;

  /// The data that will be saved and retrieved in map events.
  final Map<String, dynamic>? data;

  const Cluster({
    this.icon,
    this.iconOptions = const MapIconOptions(),
    this.isAnimated = true,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "iconOptions": iconOptions.toJson(),
        "isAnimated": isAnimated,
        "data": data,
      };

  Cluster.fromJson(Map<String, dynamic> json)
      : icon = json["icon"],
        iconOptions = MapIconOptions.fromJson(
          (json["iconOptions"] as Map<Object?, Object?>)
              .cast<String, dynamic>(),
        ),
        isAnimated = json["isAnimated"],
        data = json["data"] == null
            ? null
            : (json["data"] as Map<Object?, Object?>).cast<String, dynamic>();
}
