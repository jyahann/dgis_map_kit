import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

enum MapTheme { LIGHT, DARK }

// The basic map configuration required when creating it.
class MapConfig {
  // 2Gis Android | IOS Sdk token
  final String token;

  // Initial camera position on the map.
  final CameraPosition initialCameraPosition;

  // Initial map layers on the map.
  final List<MapLayer> layers;

  // Map theme.
  final MapTheme theme;

  const MapConfig({
    required this.token,
    required this.initialCameraPosition,
    required this.layers,
    required this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'initialCameraPosition': initialCameraPosition.toJson(),
      'layers': layers
          .map(
            (layer) => {
              "isClusterer": layer is ClustererLayer,
              "layer": layer.toJson()
            },
          )
          .toList(),
      'theme': theme.name,
    };
  }
}
