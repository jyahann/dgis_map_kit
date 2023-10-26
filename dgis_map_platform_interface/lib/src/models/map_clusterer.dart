import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class MapClusterer {
  final String? icon;
  final MapIconOptions iconOptions;
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
