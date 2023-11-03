import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

// Cluster model with its configuration.
class MapClusterer {
  // Cluster's icon based on its asset.
  final String? icon;

  // Cluster's icon options.
  final MapIconOptions iconOptions;

  // Getting and setting the cluster appearance animation flag.
  final bool isAnimated;

  const MapClusterer({
    this.icon,
    this.iconOptions = const MapIconOptions(),
    this.isAnimated = true,
  });

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "iconOptions": iconOptions.toJson(),
        "isAnimated": isAnimated,
      };

  MapClusterer.fromJson(Map<String, dynamic> json)
      : icon = json["icon"],
        iconOptions = MapIconOptions.fromJson(
          (json["iconOptions"] as Map<Object?, Object?>)
              .cast<String, dynamic>(),
        ),
        isAnimated = json["isAnimated"];
}
